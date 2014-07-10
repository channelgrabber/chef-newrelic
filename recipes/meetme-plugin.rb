#
# Cookbook Name:: newrelic
# Recipe:: meetme-plugin
#
# Copyright 2012-2014, Escape Studios
#

include_recipe node['newrelic']['meetme-plugin']['python_recipe']

license = node['newrelic']['plugin_monitoring']['license']

# install latest plugin agent
python_pip node['newrelic']['meetme-plugin']['service_name'] do
  if node['newrelic']['python-agent']['python_venv']
    virtualenv node['newrelic']['python-agent']['python_venv']
  end
  action :upgrade
end

# create the configuration, run and log directories,
# making sure they are writable by the user specified in the configuration file
files = [
  node['newrelic']['meetme-plugin']['config_file'],
  node['newrelic']['meetme-plugin']['pid_file'],
  node['newrelic']['meetme-plugin']['log_file']
]

files.each do |file|
  directory ::File.dirname(file) do
    owner node['newrelic']['meetme-plugin']['user']
    group node['newrelic']['meetme-plugin']['user']
    mode 0755
  end
end

#services_yml = nil
services = node['newrelic']['meetme-plugin']['services']


# unless services.nil?
#   require 'yaml'
#   services_yml = services.to_yaml(:indentation => 2).gsub('---', '').gsub(/!ruby\/[a-zA-Z:]*/, '')
# end


config_file = Hash.new();
config_file['Application'] = {
  'license_key' => license,
  'wake_interval' => node['newrelic']['meetme-plugin']['wake_interval']
}
unless node['newrelic']['meetme-plugin']['proxy'].nil?
  config_file['Application']['proxy'] = node['newrelic']['meetme-plugin']['proxy']
end
services.each do |service_key, service|
  config_file['Application'][service_key] = service
end

config_file['Daemon'] = {
  'user' => node['newrelic']['meetme-plugin']['user'],
  'pidfile' => node['newrelic']['meetme-plugin']['pid_file']
}

config_file['Logging'] = {
  'formatters' => {
    'verbose' => {
      'format' => "\'%(levelname) -10s %(asctime)s %(process)-6d %(processName) -15s %(threadName)-10s %(name) -45s %(funcName) -25s L%(lineno)-6d: %(message)s\'"
    }
  },
  'handlers' => {
    'file' => {
      'class' => 'logging.handlers.RotatingFileHandler',
      'formatter' => 'verbose',
      'filename' => node['newrelic']['meetme-plugin']['log_file'],
      'maxBytes' => 10485760,
      'backupCount' => 3
    }
  },
  'loggers' => {
    'newrelic-plugin-agent' => {
      'level' => 'INFO',
      'propagate' => 'True',
      'handlers' => '[console, file]'
    },
    'requests' => {
      'level' => 'ERROR',
      'propagate' => 'True',
      'handlers' => '[console, file]'
    }
  }
}


# configuration file
file node['newrelic']['meetme-plugin']['config_file'] do
  content config_file.to_yaml(:indentation => 2).gsub('---', '').gsub(/!ruby\/[a-zA-Z:]*/, '')
  owner 'root'
  group 'root'
  mode 0644
  action :create
  notifies :restart, "service[#{node['newrelic']['meetme-plugin']['service_name']}]", :delayed
end

# installing additional requirement(s)
node['newrelic']['meetme-plugin']['additional_requirements'].each do |additional_requirement|
  python_pip "newrelic-plugin-agent[#{additional_requirement}]" do
    action :upgrade
  end
end

# init script
variables = {
  :config_file => node['newrelic']['meetme-plugin']['config_file'],
  :pid_file => node['newrelic']['meetme-plugin']['pid_file']
}

case node['platform']
when 'debian', 'ubuntu'
  variables[:user] = node['newrelic']['meetme-plugin']['user']
  variables[:group] = node['newrelic']['meetme-plugin']['user']
end

template "/etc/init.d/#{node['newrelic']['meetme-plugin']['service_name']}" do
  source 'plugin/meetme/newrelic-plugin-agent.erb'
  mode 0755
  variables(
    variables
  )
end

service node['newrelic']['meetme-plugin']['service_name'] do
  supports :status => true, :start => true, :stop => true, :restart => true
  action [:enable, :start] # starts the service if it's not running and enables it to start at system boot time
end
