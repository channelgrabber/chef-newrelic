def convertChefMashToHash(mashrray)
	if mashrray.kind_of?(::Chef::Node::ImmutableMash)
		puts "###/////////////////////////////////////////////////////////////////////////////" 
		puts "Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" 
		puts "///////////////////////////////////////////////////////////////////////////////"
		mashrray = mashrray.to_hash
		mashrray.each do |key, value|
			convertChefMashToHash(value)
		end
	elsif mashrray.kind_of?(::Chef::Node::ImmutableArray)
		puts "###/////////////////////////////////////////////////////////////////////////////" 
		puts "Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" 
		puts "///////////////////////////////////////////////////////////////////////////////"
		mashrray = mashrray.to_a
		mashrray.each_index do |index|
			convertChefMashToHash(mashrray[index])
		end
	end
end