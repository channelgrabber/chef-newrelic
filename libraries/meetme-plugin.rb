def convertImmutableMashToHash(mashrray)
	if mashrray.kind_of?(::Chef::Node::ImmutableMash)
		mashrray = mashrray.to_hash
		mashrray.each do |key, value|
			mashrray[key] = convertImmutableMashToHash(value)
		end
		return mashrray
	elsif mashrray.kind_of?(::Chef::Node::ImmutableArray)
		mashrray = mashrray.to_a
		mashrray.each_index do |index|
			mashrray[index] = convertImmutableMashToHash(mashrray[index])
		end
		return mashrray
	end
	return mashrray
end