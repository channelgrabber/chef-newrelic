def convertImmutableMashToHash(mashrray)
	if mashrray.kind_of?(::Chef::Node::ImmutableMash)
		mashrray = fromImmutableMashToHash(mashrray)
		mashrray.each do |key, value|
			mashrray[key] = convertImmutableMashToHash(value)
		end
		return mashrray
	elsif mashrray.kind_of?(::Chef::Node::ImmutableArray)
		mashrray = fromImmutableArrayToArray(mashrray)
		mashrray.each_index do |index|
			mashrray[index] = convertImmutableMashToHash(mashrray[index])
		end
		return mashrray
	end
	return mashrray
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