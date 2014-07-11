def convertChefMashToHash(mashrray)
	if mashrray.kind_of?(Chef::Node::ImmutableMash)
		mashrray = mashrray.to_hash
		mashrray.each do |key, value|
			mashrray[key] = convertChefMashToHash(value)
		end
	elsif mashrray.kind_of?(Chef::Node::ImmutableArray)
		mashrray = mashrray.to_a
		mashrray.each_index do |index|
			mashrray[index] = convertChefMashToHash(mashrray[index])
		end
	end
end