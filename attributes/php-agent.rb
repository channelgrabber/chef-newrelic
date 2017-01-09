#
# Cookbook Name:: newrelic
# Attributes:: php-agent
#
# Copyright 2012-2014, Escape Studios
#

default['newrelic']['php-agent']['install_silently'] = false
default['newrelic']['php-agent']['startup_mode'] = 'agent'
default['newrelic']['php-agent']['web_server']['service_name'] = 'nginx'
default['newrelic']['php-agent']['php_recipe'] = 'cg_php::default'
default['newrelic']['php-agent']['config_file'] = '/etc/php/newrelic.ini'
