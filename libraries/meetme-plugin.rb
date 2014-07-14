def convertChefMashToHash(mashrray)
	if mashrray.kind_of?(::Chef::Node::ImmutableMash)
		mashrray = fromImmutableMashToHash(mashrray)
		mashrray.each do |key, value|
			convertChefMashToHash(value)
		end
	elsif mashrray.kind_of?(::Chef::Node::ImmutableArray)
		mashrray = fromImmutableArrayToArray(mashrray)
		mashrray.each_index do |index|
			convertChefMashToHash(mashrray[index])
		end
	end
end

def fromImmutableArrayToArray(array)
	new_array = Array.new(array.size)
	array.each_index do |index|
		new_array[index] = array[index]
	end
	return new_array
end

def fromImmutableMashToHash(mash)
	new_hash = Hash.new
	mash.each do |key, value|
		new_hash[key] = value
	end
	return new_hash
end