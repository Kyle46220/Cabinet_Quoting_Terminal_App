

# def error
#   raise ArgumentError, 'Argument is not numeric' unless x.is_a? Numeric  
#   1.0 / x  
# end  
# puts inverse(2) 


# def cab_width

# puts "enter cab_width - max 2400"
# print ">"
# cab_width = gets.chomp.to_i
# raise "please enter an integer value between 180 and 2400 inclusive." unless cab_width.is_a? Numeric && cab_width >= 180 && cab_width <=2400
# cab_width

# end

# until cab_width is_a? Numeric && cab_width >= 180 && cab_width <=2400

#     loop cab_width

# end

# begin 

#     puts "begin"

#     raise "error"

# rescue

#     puts "rescue"
   
# end


# Ruby program to illustrate 
# use of retry statement 
	
begin
    
    puts "enter cab_width - max 2400"
    print ">"
    cab_width = gets.chomp.to_i
	# using raise to create an exception 
    # raise ExceptionType, "please enter an integer value between 180 and 2400 inclusive." unless cab_width.is_a? Numeric && cab_width >= 180 && cab_width <=2400
 
    raise "hello" unless cab_width >= 180 && cab_width <=2400
    

# using Rescue method 
rescue 
    puts "enter cab_width2 - max 2400"
    print ">"
    cab_width = gets.chomp.to_i
    
    
# using retry statement 
retry unless cab_width >= 180 && cab_width <=2400
end	
  puts 'nest'



# cab_width.is_a? (Numeric && 

begin raise
rescue
    puts "enter cab_width - max 2400"
    print ">"
    cab_width = gets.chomp.to_i
    retry unless cab_width >= 180 && cab_width <=2400
end
    
