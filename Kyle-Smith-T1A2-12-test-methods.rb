size_1 = 180
size_2 = 280
size_3 = 380

array = [size_1, size_2, size_3]


# def height_constraint(height, arr, shelf_qty)
#     array = []

#     result = []

#     # arr.each do |item|
#     #     result = item*(shelf_qty+1)
#     #     array << result 
#     # end

#     # array

#     # array.each do |item|
#     #     item    
    
#     arr.each do |item|
#         array << item
#         array << item
#         array << item
#     end

#     all_combinations  = array.combination(shelf_qty+1).to_a

#     all_combinations.each do |item|
#        result << item.sum
#     end   
    

#      closest = result.uniq.sort.group_by do |item|
#         item <=> height
#     end


#     # h =result.uniq.map.sort.group_by do |e| 
#     #     e <=> 11
#     # end

#     closest[-1].last || closest[1].first
    
    
# end

# def shelf_qty_constraint(height)

#     ((height-180)/180).floor
# end


#  p shelf_qty_constraint(1100)

    
 

    
    
# p height_constraint(1100, array, 3)


def value_extractor(arr, key)


    result = arr.map do |item|    

        item.values[key]  

    end

    result.compact

end

size_1 = 180
size_2 = 280
size_3 = 380

array = [size_1,size_2,size_3]

def height_constraint(height, arr, shelf_qty)
    array = []

    result = []
    
    arr.each do |item|
        1.times do
            array << item
        end
    end


    all_combinations  = array.repeated_combination(shelf_qty+1).uniq.to_a
    # p all_combinations
    all_combinations.each do |item|
       result << item.sum
    end   
    # result

    closest = result.uniq.sort.group_by do |item|
        item <=> height
    end

#  p closest

 if closest[-1]
    adj_height =  closest[-1].last 
 elsif closest[1]
    adj_height =  closest[1].first
 else 
    puts "something went wrong! please try a different height"
 end
     
    adj_height
end

# p height_constraint(2400, array,2)

def shelf_qty_constraint(height, smallest_shelf_size, largest_shelf_size)

    max = (height-(smallest_shelf_size*2)).ceil/smallest_shelf_size
    min = height/largest_shelf_size
    min..max
end

# p shelf_qty_constraint(1400,180,480).to_a


# shelf_qty_constraint(2400,180,480).each do |item|
# p height_constraint(2400, array, item)
# end


# doesn't work if shelf amount is too many, 

# or too few. 

# need to add a minimum shelf requireemnt



# def generate_all_combinations(array, max_shelves)
#     array.repeated_permutation(max_shelves).to_a
#   end



# result = []
# (1..12).each do |i|
#     generate_all_combinations(array, i).each do |i|
#         result << i.sum
#     end
#     p result.flatten.flatten.uniq.delete_if {|i| i > 2400}
# end

def generate_all_combinations(array, max)
    result  = []
    result_array = []

    (1..max.to_i).each do |i|
        array.repeated_permutation(i).to_a.each do |i|
            result << i.sum
        end
        result_array << result.flatten.uniq.delete_if { |i| i > 2400 }
        
    end
    result_array
end

# shelf_options_array = generate_all_combinations(array,12)



new_arr = []
(1..12).each do |i|
   result = generate_all_combinations(array, i).sum
   new_arr << result
end
 p new_arr
 
def height_suggester(options_array, height, shelf_qty)  

adj_height_array=[]

closest = options_array[shelf_qty.to_i].group_by do |item|
    item <=> height
end


if closest[0]
    adj_height_array << closest[-1].last
    adj_height_array << closest[0][0]    
    adj_height_array << closest[1].first
elsif closest[-1]
    adj_height_array << closest[-1].last
    adj_height_array << closest[-1][-1]
    adj_height_array << closest[1].first
    adj_height_array << closest[1][1]
elsif closest[1]
    adj_height << closest[1].first
    adj_height << closest[1][1]
else
    puts "error"
end

adj_height_array.uniq.delete_if {|i| i==nil}

end

# p height_suggester(shelf_options_array, 1500,5) 

def shelf_qty_constraint(height, smallest_shelf_size, largest_shelf_size)

    max = (height.to_f-(smallest_shelf_size*2))/smallest_shelf_size
    min = height.to_f/largest_shelf_size
    result = min.ceil..max.floor
    result.to_a
end

def shelf_qty_constraint(height, smallest_shelf_size, largest_shelf_size)
    height = height.to_f
    max = (height-(smallest_shelf_size*2))/smallest_shelf_size
    min = height/largest_shelf_size
    if max == min
        result = max.to_a
    else        
    result = min.ceil..max.floor
    end
    result.to_a 
end

# biko = shelf_qty_constraint(1500,180,480)

# p biko
# p biko.first
# p biko.last

def height_checker(arr, val)
    result = []
    if arr.include?(val)
        result << val
    else 
        result << arr
    end

    result.flatten

end

# p height_checker([1,2,3],4)

def height_checker(arr, val)

    if arr.include?(val.to_i)
        result = val
    else
        result << arr
    end
end

# p (1..5).to_a

# a = (1..10).to_a
# b = (11..20).to_a
# c = (21..30).to_a

def array_joiner( *arr)
   p arr
    array = []        
    array << arr
    array.flatten.flatten

end

#  p array_joiner(a,b,c)



