def convertChefMashToHash(mashrray)
	if mashrray.is_a?(Chef::Node::ImmutableMash)
		mashrray = mashrray.to_hash
		mashrray.each do |key, value|
			mashrray[key] = convertChefMashToHash(value)
		end
	end
	if mashrray.is_a?(Chef::Node::ImmutableArray)
		mashrray = mashrray.a
		mashrray.each_index do |index|
			mashrray[index] = convertChefMashToHash(mashrray[index])
		end
	end
end