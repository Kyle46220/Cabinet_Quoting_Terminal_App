# frozen_string_literal: true

### fuk yeh ###

require 'tty-prompt'
require 'colorize'
require 'rubocop'
require 'date'
require 'tty-font'

font = TTY::Font.new(:standard)

prompt = TTY::Prompt.new

size_1 = 180
size_2 = 280
size_3 = 380

array = [size_1, size_2, size_3]

customer_name = []

def add_new_customer(customer_name)
  customer_name << ARGV[0]
end

add_new_customer(customer_name)

date = []

def add_date_stamp(date)
  date << ARGV[0]
end

add_date_stamp(date)

def shelf_qty_constraint(height, smallest_shelf_size, largest_shelf_size)
  result = []
  height = height
  max = (height - (smallest_shelf_size * 2)) / smallest_shelf_size
  min = (height / largest_shelf_size)
  # p min
  # p max
  result << if max == min
              max
            else
              (min..max).to_a
            end
  result.flatten
end

def generate_all_combinations(array, max)
  result = []
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
  adj_height_array = []

  closest = options_array[shelf_qty.to_i].sort.group_by do |item|
    item <=> height
  end

  if closest[0]
    # p closest[0]
    adj_height_array << closest[-1][-1]
    adj_height_array << closest[0][0]
    adj_height_array << closest[1][0] if closest[1]
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
    puts 'error'
  end

  adj_height_array.uniq.delete_if(&:nil?)
end

def height_checker(arr, val)
  result = []
  result << if arr.include?(val)
              val
            else
              arr
            end

  result.flatten
end
puts font.write('FAB CABS').colorize(:light_magenta)
prompt.keypress('Welcome to FAB CABS - cabinet quoting and configuring app. Press space or enter to continue', keys: %i[space return])

cab_depth = prompt.select('Please select the depth of your cabinet', %w[280 380 580], convert: :int)

# cab_width = prompt.ask('please select the width - max 2400', default: 1000, convert: :int)

begin raise
rescue StandardError
  puts 'Pleas2 enter cab_width - min 200 <=> max 2400'
  print '>'
  cab_width = gets.chomp.to_i
  retry unless cab_width >= 200 && cab_width <= 2400
end

begin raise
rescue StandardError
  puts 'Please enter cab_height - min 200 <=> max 2400'
  print '>'
  height_input = gets.chomp.to_i
  retry unless height_input >= 200 && height_input <= 2400
end

# height_input = prompt.ask('please select the preffered cabinet height - max 2400', default: 1000, convert: :int)

shelf_qty_constraint_array = shelf_qty_constraint(height_input, size_1, size_2)

min_shelf = shelf_qty_constraint_array.first

max_shelf = shelf_qty_constraint_array.last

if shelf_qty_constraint_array.length > 1

  shelves = prompt.slider('Please select shelf qty', min: min_shelf.to_s, max: max_shelf.to_s, step: 1, convert: :int)
else
  shelves = min_shelf.to_i
  prompt.say("only #{min_shelf} shelves available at this height. increase height to add more")

end

new_height = height_suggester(shelf_combo_array, height_input, shelves)

available_height = height_checker(new_height, height_input)

if available_height != height_input

  new_height_select = prompt.select('height not available. please select from:', available_height, convert: :int)

else new_height_select = height_input

end

colour = prompt.select('Choose cabinet colour', %w[black white red natural])

project_hash = {
  height: new_height_select.to_i,
  width: cab_width.to_i,
  depth: cab_depth.to_i,
  shelves: shelves.to_i,
  cupboards: [],
  drawers: [],
  colour: colour,
  material_thickness: 18

}
materials_list = {
  plywood: {
    name: 'plywood',
    price: 100,
    type: 'panel'
  },
  shelf_support: {
    name: 'shelf_support',
    price: 1,
    type: 'fixing'

  },
  connector: {
    name: 'connector',
    price: 4,
    type: 'fixing'
  }
}

total_price = []

def cabinet_carcasse_parts_generator(cabinet_height, cabinet_width, cabinet_depth, material_thickness)
  carcasse_array = []

  two_times_thk = material_thickness * 2

  side_length = cabinet_height - two_times_thk

  top = {
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

def divider_parts_generator(cabinet_height, _cabinet_width, cabinet_depth, material_thickness)
  div_array = []

  div = {
    part_length: cabinet_height - (2 * material_thickness),
    part_width: cabinet_depth,
    part_thickness: material_thickness
  }

  div_array << div

  div_array
end

def divider_quantity_calculator(cabinet_width)
  if cabinet_width < 700
    0
  elsif cabinet_width >= 700 && cabinet_width < 1200
    1
  elsif cabinet_width >= 1200 && cabinet_width < 1700
    2
  elsif cabinet_width >= 1700 && cabinet_width < 2200
    3

  elsif cabinet_width >= 2200 && cabinet_width <= 2400
    4

  end
end

def part_assigner(part_qty, method)
  result = []
  part_qty.to_i
  part_qty.times do
    result << method
  end
  result
end

def shelf_parts_generator(_cabinet_height, cabinet_width, cabinet_depth, material_thickness)
  shelf_array = []

  shelf = {
    part_length: cabinet_width - (2 * material_thickness),
    part_width: cabinet_depth,
    part_thickness: material_thickness
  }

  shelf_array << shelf

  shelf_array
end

def array_joiner(*arr)
  # p arr
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
  row7 = []
  row8 = []
  row9 = []
  row10 = []
  row11 = []
  row12 = []
  row13 = []
  row14 = []
  row15 = []
  row16 = []
  row17 = []
  row18 = []
  row19 = []
  row20 = []
  row21 = []
  row22 = []
  row23 = []
  row24 = []

  arr.each do |item|
    if row1.sum + item < 2400
      row1 <<  item if item == arr[0]

    elsif row2.sum + item < 2400
      row2 <<  item if item == arr[0]

    elsif row3.sum + item < 2400
      row3 <<  item if item == arr[0]

    elsif row4.sum + item < 2400
      row4 <<  item if item == arr[0]

    elsif row5.sum + item < 2400
      row5 <<  item if item == arr[0]

    elsif row6.sum + item < 2400
      row6 <<  item if item == arr[0]

    elsif row7.sum + item < 2400
      row7 <<  item if item == arr[0]
    elsif row8.sum + item < 2400
      row8 <<  item if item == arr[0]
    elsif row9.sum + item < 2400
      row9 <<  item if item == arr[0]
    elsif row10.sum + item < 2400
      row10 <<  item if item == arr[0]
    elsif row11.sum + item < 2400
      row11 <<  item if item == arr[0]
    elsif row12.sum + item < 2400
      row12 <<  item if item == arr[0]
    elsif row13.sum + item < 2400
      row13 <<  item if item == arr[0]
    elsif row14.sum + item < 2400
      row14 <<  item if item == arr[0]
    elsif row15.sum + item < 2400
      row15 <<  item if item == arr[0]
    elsif row16.sum + item < 2400
      row16 <<  item if item == arr[0]
    elsif row17.sum + item < 2400
      row17 <<  item if item == arr[0]
    elsif row18.sum + item < 2400
      row18 <<  item if item == arr[0]
    elsif row19.sum + item < 2400
      row19 <<  item if item == arr[0]
    elsif row20.sum + item < 2400
      row20 <<  item if item == arr[0]
    elsif row21.sum + item < 2400
      row21 << item if item == arr[0]
    elsif row22.sum + item < 2400
      row22 <<  item if item == arr[0]
    elsif row23.sum + item < 2400
      row23 <<  item if item == arr[0]
    elsif row24.sum + item < 2400
      row24 <<  item if item == arr[0]

    end

    arr = arr.drop(1)
  end

  result << row1
  result << row2
  result << row3
  result << row4
  result << row5
  result << row6
  result << row7
  result << row8
  result << row9
  result << row10
  result << row11
  result << row12
  result << row13
  result << row14
  result << row15
  result << row16
  result << row17
  result << row18
  result << row19
  result << row20
  result << row21
  result << row22
  result << row23
  result << row24

  remove_empty_rows = result.reject(&:empty?)

  remove_empty_rows
end

def sheet_counter(arr, depth)
  sheet_qty = if depth < 296
                arr.length / 4.0

              elsif depth >= 296 && depth < 396

                arr.length / 3.0

              elsif depth >= 396 && depth < 596

                arr.length / 2.0

              else arr.length

              end

  sheet_qty.ceil
end

def value_extractor(arr, _key)
  result = arr.map do |item|
    item.values[0]
  end

  result.compact.sort.reverse
end

carcasse_parts = cabinet_carcasse_parts_generator(project_hash[:height], project_hash[:width], project_hash[:depth], project_hash[:material_thickness])

div_part_size = divider_parts_generator(project_hash[:height], project_hash[:width], project_hash[:depth], project_hash[:material_thickness])

assigned_dividers = part_assigner(divider_quantity_calculator(project_hash[:width]), divider_parts_generator(project_hash[:height], project_hash[:width], project_hash[:depth], project_hash[:material_thickness]))

shelf_parts_size = shelf_parts_generator(project_hash[:height], project_hash[:width], project_hash[:depth], project_hash[:material_thickness])

shelf_quantity_constraint = shelf_qty_constraint(project_hash[:height], size_1, size_3)

assigned_shelf_parts = part_assigner(shelves.to_i, shelf_parts_generator(project_hash[:height], project_hash[:width], project_hash[:depth], project_hash[:material_thickness]))

complete_parts_array = array_joiner(carcasse_parts, assigned_dividers, assigned_shelf_parts)

divider_quantity = divider_quantity_calculator(project_hash[:width])

part_length_array = value_extractor(complete_parts_array, project_hash[:length])

row_array = row_builder(part_length_array)

plywood_total = sheet_counter(row_array, project_hash[:depth].to_i)

def machining_length_estimate(arr)
  # p arr
  result = arr.map do |item|
    item.values[0..3]
  end

  result.flatten.sum
end

def machining_handling_qty(_arr)
  array.length
end

def fixing_qty(qty_per_join, *arr)
  array = []
  array << arr

  array.flatten.flatten
  # if array.length > 1
  #     array.flatten
  # end
  array.length * qty_per_join
end

def price_calculator(qty, price)
  qty * price
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
  item.sum * mark_up
end

final_price = mark_up(3, panel_cost, connector_cost, shelf_support_cost) + mark_up(1.3, machining_cost)

line_00 = customer_name

puts 'cabinet details'.colorize(:light_blue)
puts

line_0 = "#{project_hash}\n"

puts line_0.colorize(:light_magenta)

puts 'cut list'.colorize(:light_blue)
puts

line_01 = "width:#{project_hash[:depth]}| lengths:#{row_array}"

puts line_01.colorize(:light_magenta)
puts

puts 'BOM'.colorize(:light_blue)
puts

line_1 = "#{materials_list[:plywood][:name]} | Qty:#{plywood_total} | $#{panel_cost}\n"

puts line_1.colorize(:light_magenta)
line_2 = "#{materials_list[:connector][:name]} | Qty:#{connector_qty} | $#{connector_cost}\n"
puts line_2.colorize(:light_magenta)

line_3 = "#{materials_list[:shelf_support][:name]} | Qty:#{shelf_support_qty} | $#{shelf_support_cost}\n"
puts line_3.colorize(:light_magenta)

line_4 = "Total machining length | Qty(mm):#{total_machining_length} | $#{panel_cost}\n"
puts line_4.colorize(:light_magenta)

line_5 = "Total handling | Qty:#{total_pieces} | $#{price_calculator(total_pieces, handling_fee_per_piece)}\n"
puts line_5.colorize(:light_magenta)
puts

puts 'final price:'.colorize(:light_blue)

puts

line_6 = "$#{final_price}\n"

puts line_6.colorize(:light_magenta)

save = prompt.yes?('Save cabinet details?')

unless customer_name.empty?

  File.open('cabinet.csv', 'a') do |row|
    row << "#{customer_name}\n"
  end
end

if save
  File.open('cabinet.csv', 'a') do |row|
    row << "---------------------------------\n"
    row << "#{DateTime.now}\n"
    row << line_00
    row << line_0
    row << "cut list:#{line_01}\n"
    row << line_1
    row << line_2
    row << line_3
    row << line_4
    row << "final_price: #{line_6}\n"
    row << "---------------------------------\n"
  end
else exit
end
