
### fucken box maj

require 'tty-prompt'

prompt = TTY::Prompt.new

size_1 = 180
size_2 = 280
size_3 = 380

array = [size_1,size_2,size_3]

def height_constraint(height, arr, shelf_qty)
    array = []

    result = []
    
    arr.each do |item|
        array << item
        array << item
        array << item
    end

    all_combinations  = array.combination(shelf_qty+1).to_a

    all_combinations.each do |item|
       result << item.sum
    end   
    

    closest = result.uniq.sort.group_by do |item|
        item <=> height
    end


    closest[-1].last || closest[1].first
     
    
end

def shelf_qty_constraint(height, smallest_shelf_size)

    (height-(smallest_shelf_size*2))/-smallest_shelf_size

end




puts "Welcome to Box Majik"


prompt.keypress("Press space or enter to continue", keys: [:space, :return])


cab_depth = prompt.select("Choose cabinet depth", %w(280 380 580), convert: :int)

cab_width = prompt.ask('cab width?', default: 1000, convert: :int)


height_input= prompt.ask('cab_height?', default: 1000, convert: :int) 

new_height = height_constraint(height_input.to_i, array, shelf_qty_constraint(height_input, size_1))
    
new_height_select = prompt.yes?("height not available, is #{new_height} ok?" )

shelves = prompt.ask('shelf qty?', default: 0, convert: :int) 

new_shelves_limit = shelf_qty_constraint(new_height)

if shelves.to_i > new_shelves_limit.to_i

   prompt.yes?("Too many shelves. is #{new_shelves} ok") && new_shelves_select = new_shelves_limit

else new_shelves_select = shelves

end



colour = prompt.select("Choose cabinet colour", %w(black white red natural))

project_hash =  {    
    height: new_height.to_i,
    width: cab_width.to_i,
    depth: cab_depth.to_i,
    shelves: new_shelves_select ,
    cupboards: [],
    drawers: [],
    colour: colour,
    material_thickness: 18
    
}
materials_list = {
plywood: {
    name: "plywood",
    price:100,
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

    elsif depth >=296
        if depth < 396  ### to be able to insert these values if they were methods? 
            sheet_qty = arr.length/3.0
        end

    elsif depth >=396
        if depth < 596
            sheet_qty = arr.length/2.0
        end

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

shelf_quantity_constraint = shelf_qty_constraint(project_hash[:height])

adjusted_height =  height_constraint(project_hash[:height], array, shelf_quantity_constraint)

assigned_shelf_parts = part_assigner(shelf_qty_constraint(project_hash[:height]),shelf_parts_generator(project_hash[:height],project_hash[:width],project_hash[:depth],project_hash[:material_thickness]))

complete_parts_array = array_joiner(3, carcasse_parts, assigned_dividers, assigned_shelf_parts)

divider_quantity = divider_quantity_calculator(project_hash[:width])



part_length_array = value_extractor(complete_parts_array, project_hash[:length])

row_array = row_builder(part_length_array)

plywood_total = sheet_counter(row_array, project_hash[:depth])

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

machining_fee_per_mm = 0.01

handling_fee_per_piece = 2.5

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

p panel_cost
p connector_cost
p shelf_support_cost
p machining_cost

def mark_up(mark_up, *item)
   item.sum*mark_up
end

final_price = mark_up(3, panel_cost, connector_cost, shelf_support_cost)+ mark_up(1.3, machining_cost)

puts "final price:"

p final_price

























