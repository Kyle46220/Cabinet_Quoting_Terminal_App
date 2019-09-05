
### fucken box maj

require 'tty-prompt'

prompt = TTY::Prompt.new

size_1 = 180
size_2 = 280
size_3 = 380

array = [size_1,size_2,size_3]

# def height_constraint(height, arr, shelf_qty)
#     array = []

#     result = []
    
#     arr.each do |item|
#         1.times do
#             array << item
#         end
#     end


#     all_combinations  = array.repeated_combination(shelf_qty+1).uniq.to_a
#     # p all_combinations
#     all_combinations.each do |item|
#        result << item.sum
#     end   
#     # result

#     closest = result.uniq.sort.group_by do |item|
#         item <=> height
#     end

#  p closest

#  if closest[-1]
#     adj_height =  closest[-1].last 
#  elsif closest[1]
#     adj_height =  closest[1].first
#  else 
#     puts "something went wrong! please try a different height or shelf qty"
#  end
     
#     adj_height
# end

def shelf_qty_constraint(height, smallest_shelf_size, largest_shelf_size)
    result = []
    height = height
    max = (height-(smallest_shelf_size*2))/smallest_shelf_size
    min = (height/largest_shelf_size)
    # p min
    # p max
    if max == min
        result << max
    else        
        result << (min..max).to_a
    end
    result.flatten
end

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

shelf_combo_array = generate_all_combinations(array, 12)

def height_suggester(options_array, height, shelf_qty)  

    adj_height_array=[]

    # p options_array
    # p height

    # if height < 500

    #     adj_height_array << 360

    closest = options_array[shelf_qty.to_i].sort.group_by do |item|
        item <=> height
    end
    #  p closest
    
    
    if closest[0]
        # p closest[0]
        adj_height_array << closest[-1][-1]
        adj_height_array << closest[0][0]    
        adj_height_array << closest[1][0]
    elsif closest[-1]
        # p closest[-1]
        adj_height_array << closest[-1][-1]
        adj_height_array << closest[-1][-2]
        adj_height_array << closest[-1][-3]
        # adj_height_array << closest[1][1]
            if closest[1]
                # p closest[1]
                adj_height_array << closest[1][0]
                adj_height_array << closest[1][1]
            end
    else
        puts "error"
    end
    
    adj_height_array.uniq.delete_if {|i| i==nil}
    
end


def height_checker(arr, val)
    result = []
    if arr.include?(val)
        result << val
    else 
        result << arr
    end

    result.flatten

end




prompt.keypress("Welcome to Box Majik. Press space or enter to continue", keys: [:space, :return])

cab_depth = prompt.select("Please select the depth of your cabinet", %w(280 380 580), convert: :int)

# cab_width = 0

cab_width = prompt.ask('please select the width - max 2400', default: 1000, convert: :int)

height_input = prompt.ask('please select the preffered cabinet height - max 2400', default: 1000, convert: :int) 
# p height_input

shelf_qty_constraint_array = shelf_qty_constraint(height_input, size_1, size_2)

# p shelf_qty_constraint_array

min_shelf = shelf_qty_constraint_array.first

max_shelf = shelf_qty_constraint_array.last

# p min_shelf
# p max_shelf

if shelf_qty_constraint_array.length > 1

    shelves = prompt.slider('Please select shelf qty', min: "#{min_shelf}", max: "#{max_shelf}", step: 1, convert: :int) 
else
    shelves = min_shelf
    prompt.say("only #{min_shelf} shelves available at this height. increase height to add more")

end

# p shelf_combo_array

new_height = height_suggester(shelf_combo_array, height_input, shelves)

# p new_height

available_height = height_checker(new_height, height_input)

puts available_height

# choices = {available_height[0]=>  1, available_height[1]=> 2, available_height[2]=> 3}

if available_height != height_input
    
    new_height_select = prompt.select("height not available. please select from:", available_height, convert: :int )

else new_height_select = height_input

end



# new_shelves_limit = shelf_qty_constraint(new_height, size_1)

# if shelves.to_i > new_shelves_limit.to_i

#    prompt.yes?("Too many shelves. is #{new_shelves_limit} ok") && new_shelves_select = new_shelves_limit

# else new_shelves_select = shelves

# end



colour = prompt.select("Choose cabinet colour", %w(black white red natural))

project_hash =  {    
    height: new_height_select,
    width: cab_width,
    depth: cab_depth.to_i,
    shelves: shelves,
    cupboards: [],
    drawers: [],
    colour: colour,
    material_thickness: 18
    
}
materials_list = {
plywood: {
    name: "plywood",
    price: 100,
    type: "panel"
},
shelf_support: {
    name: "shelf_support",
    price: 1,
    type: "fixing"
    
},
connector: {
    name: "connector",
    price: 4,
    type: "fixing"
}
}

total_price = []

# size_1 = 180
# size_2 = 280
# size_3 = 380

# array = [size_1,size_2,size_3]

#############

















#############

def cabinet_carcasse_parts_generator(cabinet_height, cabinet_width, cabinet_depth, material_thickness)

    carcasse_array = []

    two_times_thk = material_thickness*2
#  p cabinet_height
    side_length = cabinet_height - two_times_thk

    top =  {
        part_length: cabinet_width, 
        part_width: cabinet_depth, 
        part_thickness: material_thickness
    }

    bottom = {
        part_length: cabinet_width, 
        part_width: cabinet_depth, 
        part_thickness: material_thickness
    }

    side_L = {
        part_length: side_length,
        part_width: cabinet_depth, 
        part_thickness: material_thickness
    }

    side_R = {
        part_length: side_length,
        part_width: cabinet_depth, 
        part_thickness: material_thickness
    }


    carcasse_array << top
    carcasse_array << bottom
    carcasse_array << side_L
    carcasse_array << side_R
    carcasse_array
end

def divider_parts_generator(cabinet_height, cabinet_width, cabinet_depth, material_thickness)
    div_array = []

    div={
        part_length: cabinet_height - (2*material_thickness),
        part_width: cabinet_depth,
        part_thickness: material_thickness
    }

    div_array << div

    div_array

end

def divider_quantity_calculator(cabinet_width)
    
  
    if cabinet_width < 700
       return 0
    elsif cabinet_width >= 700 && cabinet_width <1200
        return 1
    elsif cabinet_width >= 1200 && cabinet_width <1700
       return 2
    elsif cabinet_width >= 1700
        if cabinet_width <2200
           return 3
        end
    elsif cabinet_width >= 2200
        if cabinet_width <=2400
           return 4
        end
    end   
    
end

def part_assigner(part_qty, method)
    result = []
    part_qty.to_i
    part_qty.times do
      result  << method
    end
    result
end

def shelf_parts_generator(cabinet_height, cabinet_width, cabinet_depth, material_thickness)
    shelf_array = []

    shelf = {
        part_length: cabinet_width- (2*material_thickness),
        part_width: cabinet_depth,
        part_thickness: material_thickness
    }

    shelf_array << shelf

    shelf_array

end

# def height_constraint(height, arr, shelf_qty)
#     array = []

#     result = []
    
#     arr.each do |item|
#         array << item
#         array << item
#         array << item
#     end

#     all_combinations  = array.combination(shelf_qty+1).to_a

#     all_combinations.each do |item|
#        result << item.sum
#     end   
    

#     closest = result.uniq.sort.group_by do |item|
#         item <=> height
#     end


#     closest[-1].last || closest[1].first
     
    
# end

# def shelf_qty_constraint(height)

#     ((height-180-180)/180)

# end

def array_joiner(qty_to_join, *arr)

    array = []        
    array << arr
    array.flatten.flatten

end

def row_builder(arr)

    result = []
    row1 = []
    row2 = []
    row3 = []
    row4 = []
    row5 = []
    row6 = []

    arr.each do |item|

        if row1.sum + item < 2400
            if item == arr[0]
                row1 <<  item              

            end 

        elsif row2.sum + item < 2400
            if item == arr[0]
                row2 <<  item               
            end 
    
        elsif row3.sum + item < 2400
            if item == arr[0]
                row3 <<  item
            end 

        elsif row4.sum + item < 2400
            if item == arr[0]
                row4 <<  item               
            end 

        elsif row5.sum + item < 2400
            if item == arr[0]
                row5 <<  item               
            end 

        elsif row6.sum + item < 2400
            if item == arr[0]
                row6 <<  item               
            end 

        end  

        arr = arr.drop(1)
        
    end

    result << row1
    result << row2
    result << row3
    result << row4
    result << row5
    result << row6

    remove_empty_rows = result.reject do |x|
         x.empty?
    end

    remove_empty_rows

end

def sheet_counter(arr, depth)

    if depth < 296
        sheet_qty = arr.length/4.0

    elsif depth >=296 && depth < 396  

        sheet_qty = arr.length/3.0


    elsif depth >=396 && depth < 596

        sheet_qty = arr.length/2.0
        
    else sheet_qty = arr.length
    
    end

    sheet_qty.ceil

end

def value_extractor(arr, key)


    result = arr.map do |item|    

        item.values[0]  

    end

    result.compact.sort.reverse

end

carcasse_parts = cabinet_carcasse_parts_generator(project_hash[:height], project_hash[:width], project_hash[:depth], project_hash[:material_thickness])

div_part_size = divider_parts_generator(project_hash[:height],project_hash[:width],project_hash[:depth],project_hash[:material_thickness])

assigned_dividers = part_assigner(2, divider_parts_generator(project_hash[:height],project_hash[:width],project_hash[:depth],project_hash[:material_thickness]))

shelf_parts_size = shelf_parts_generator(project_hash[:height],project_hash[:width],project_hash[:depth],project_hash[:material_thickness])

shelf_quantity_constraint = shelf_qty_constraint(project_hash[:height], size_1, size_3)

# adjusted_height =  height_constraint(project_hash[:height], array, shelf_quantity_constraint)

# assigned_shelf_parts = part_assigner(shelf_qty_constraint(project_hash[:height], size_1,size_3),shelf_parts_generator(project_hash[:height],project_hash[:width],project_hash[:depth],project_hash[:material_thickness]))

assigned_shelf_parts = part_assigner(shelves,shelf_parts_generator(project_hash[:height],project_hash[:width],project_hash[:depth],project_hash[:material_thickness]))

complete_parts_array = array_joiner(3, carcasse_parts, assigned_dividers, assigned_shelf_parts)

divider_quantity = divider_quantity_calculator(project_hash[:width])



part_length_array = value_extractor(complete_parts_array, project_hash[:length])

row_array = row_builder(part_length_array)

p row_array

plywood_total = sheet_counter(row_array, project_hash[:depth].to_i)

# p part_length_array

# puts "carcasse parts:"
# p carcasse_parts

# puts "divider part size:"
# p div_part_size

# puts "divider quantity:"
# p divider_quantity

# puts "divider parts:"

# p assigned_dividers

# puts "shelf part size"

# p shelf_parts_size


# puts "max allowable shelves"

# p shelf_quantity_constraint

# puts "shelf parts:"

# p assigned_shelf_parts

# puts "height constraint:"

# p adjusted_height

# "full parts list:"

# p complete_parts_array

# puts "cut list"
# puts "#{project_hash[:depth]}:#{row_array}"

# puts "total_plywood"

# p plywood_total



def machining_length_estimate(arr)
    p arr
    result = arr.map do |item|    

        item.values[0..3] 

    end

    result.flatten.sum

end

def machining_handling_qty(arr)

    array.length

end



def fixing_qty(qty_per_join,*arr)
    array =[]
    array << arr

    array.flatten.flatten
    # if array.length > 1 
    #     array.flatten
    # end
    array.length*qty_per_join
end

def price_calculator(qty, price)
    qty*price
end

machining_fee_per_mm = 0.008

handling_fee_per_piece = 2

panel_cost = price_calculator(plywood_total, materials_list[:plywood][:price])

connectors_per_panel = 4

supports_per_shelf = 8

carcasse_sides = carcasse_parts.drop(2)

connector_qty = fixing_qty(connectors_per_panel, assigned_dividers, carcasse_sides)


shelf_support_qty = fixing_qty(supports_per_shelf, assigned_shelf_parts)

connector_cost = price_calculator(connector_qty, materials_list[:connector][:price])

shelf_support_cost = price_calculator(shelf_support_qty, materials_list[:shelf_support][:price])


total_machining_length = machining_length_estimate(complete_parts_array)

total_pieces = complete_parts_array.length

machining_cost = price_calculator(total_machining_length, machining_fee_per_mm) + price_calculator(total_pieces, handling_fee_per_piece)

# p machining_cost






def mark_up(mark_up, *item)
   item.sum*mark_up
end

final_price = mark_up(3, panel_cost, connector_cost, shelf_support_cost)+ mark_up(1.3, machining_cost) 


puts "cabinet details"

puts project_hash

puts "BOM"
 
line_1 =  "#{materials_list[:plywood][:name]} | #{plywood_total} | #{panel_cost}\n"

puts line_1
line_2 = "#{materials_list[:connector][:name]} | #{connector_qty} | #{connector_cost}\n"
puts line_2

line_3 = "#{materials_list[:shelf_support][:name]} | #{shelf_support_qty} | #{shelf_support_cost}\n"
puts line_3

line_4 = "Total machining length | #{total_machining_length} | #{panel_cost}\n"
puts line_4

line_5 = "Total handling  | #{total_pieces} | #{price_calculator(total_pieces, handling_fee_per_piece)}\n"
puts line_5
   
puts "final price:"


line_6 = "$#{final_price}\n"

puts line_6

save = prompt.yes?('Save cabinet details?')

# require 'csv'

# csv_text = File.open('cabinet.csv', "a")

# csv = CSV.parse(csv_text, :headers => false)

 
if save  
    File.open('cabinet.csv', "a") do |row|
        row << line_1
        row << line_2
        row << line_3
        row << line_4
        row << line_6
    end
else exit
end




































