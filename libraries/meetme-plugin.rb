def convertChefMashToHash(mashrray)
	if mashrray.kind_of?(::Chef::Node::ImmutableMash)
		mashrray = fromImmutableMashToHash(mashrray)
		mashrray.each do |key, value|
			mashrray[key] = convertChefMashToHash(value)
		end
	elsif mashrray.kind_of?(::Chef::Node::ImmutableArray)
		mashrray = fromImmutableArrayToArray(mashrray)
		mashrray.each_index do |index|
			mashrray[index] = convertChefMashToHash(mashrray[index])
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

class Chef
  class Node
   class ImmutableMash
      def to_hash
        h = {}
        self.each do |k,v|
          if v.respond_to?('to_hash')
            h[k] = v.to_hash
          else
            h[k] = v
          end
        end
        return h
      end
    end
  end
end