# Devlopment Log #

## Terminal App Assignment ##
### Kyle Smith ###


3/09/2019

Initial Function experiments. 

I've started out with trying to build a method do to what I think is the most difficult aspect of the app: the nesting of parts to be cut into available material sheet sizes. I've started with  an array of hashes which shows a list of parts to be cut - 

```Ruby 
    parts_array = [{
    thickness: 18,
    length: 1800,
    width: 380
},
{
    thickness: 18,
    length: 900,
    width: 380
},
{
    thickness: 18,
    length: 2100,
    width: 380
},
{
    thickness: 18,
    length: 400,
    width: 380
}] 
```
This array  will be generated from a calculations based on user input. 

the material sheet size is 2400 * 1200mm and the challenge is to find the most efficient use, or at least an efficient use of materials by arranging the parts differently on the sheet. 

To make this task simpler, I have decided to orient all the part in one direction, and place them in set width rows. either 3*400mm or 4*300mm depending on cabinet depth. 

The following example shows the idea. 

[example of plywood panel optimisation](Sheet_optimser_example.jpg)


From here the idea is to select parts from the array and combing them until their lengths add up to the sheet size of 2400 and then move onto the next row. 

I am experimenting with 
 - sampling from the array using .sample and Rand
 - summing all all values from a specific key in each hash using .inject

 - .combination(n)

 ## ***UPDATE*** 04/09 ##

 So I've made progress on the nesting method. I ended up extracting the length value from the hashes, putting it into an array.sort.reverse to put longest lengths first, and then using a method to iterate through the array, and grouping the items into groups or "rows" with sums of less than 2400 (this being the length of the stock plywood, the pieces are to be cut from) 

 ```` Ruby
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
````

This can be improved because I am repeating myself alot in this code, but it gives the result I want reliably so I'm leaving it for now. 

 I've also added a simple material quantity calculator that calculates from the qty of rows, how many sheets of plywood I'll need based on how many rows I can fit per sheet. 
 there's some hardcoding in this method that I want to get rid of but I will fix that later. i'm thinking maybe some simple methods like 

 ````Ruby
 def depth(num)

    num

 end
 ````

 I will then be able to call these from inside the sheet_counter method. 


 this method takes the array of rows I created with the previous method, and a row depth (based on user input). Based on plywood sheet size 1200*2400

 ```` Ruby
 def sheet_counter(arr, depth)

    if depth < 296
        sheet_qty = arr.length/4

    elsif depth >=296
        if depth < 396  ### how am I able to insert these values. maybe if they were methods? 
            sheet_qty = arr.length/3
        end

    elsif depth >=396
        if depth < 596
            sheet_qty = arr.length/2
        end

    else sheet_qty = arr.length
    
    end

    sheet_qty

end
````

I think this is the hardest work done, next steps are going to be to get user input for dimensions of the cabinet, and to generate an array of hashes, representing the pieces to be cut, which will then go into the methods I've just made. 

For this step the user inputs I want to have are 
width - specify any
height - has to be a multiple of fixed shelf heights - 180, 280, 380,
depths - one of 3 options. 280, 380, 580

if there's time, also these three. 

 - drawers - all or none per shelf 

 - cupboards - all or none per shelf

 - materials choice - natural, black or white, or red, blue, yellow. 3 price categories. 


The width will determine vertical shelf supports. 

And then I will have to build a database of materials I can add to, and a user interface and menu. and the output file formatting. 

The most important data type is going to be the hash. I think I will create a hash for the piece of furniture to be made, then add to this. I'm going ot call this the project hash. also an array of hashes will be generated as well that are the pices of plywood to build the cabinet. the hashes are called parts. 

there will be two steps 
 - step one take user input and add it to a project hash
 - generate parts array hashes from project hash


##***UPDATE***##

04/09

Have got a working MVP from project_hash to output. 

takes a project hash

```` ruby
project_hash =  {    
    height: 800,
    width: 1500,
    depth: 380,
    shelves: 2,
    cupboards: [],
    drawers: [],
    colour: "natural",
    material_thickness: 18
    
}
````

Then through several methods the following outputs are generated
````
carcass parts:
[{:part_length=>600, :part_width=>400, :part_thickness=>18}, {:part_length=>600, :part_width=>400, :part_thickness=>18}, {:part_length=>1164, :part_width=>400, :part_thickness=>18}, {:part_length=>1164, :part_width=>400, :part_thickness=>18}]
divider_parts:
[{:length=>764, :width=>380, :thickness=>18}]
divider quantity:
0
divider assigner:
[]
height constraint:
740
max allowable shelves
3

````


I need to add shelf part hashes, join the hashes into a single array of hashes, then send this to the other nesting optimiser thing.

###**UPDATE**### 06/09

So yesterday was spent mostly doing the logic for the terminal prompt. One of the features of the app, was that it would take preset shelf heights (that are based on supplier constraints) and then from these, constraint the height of the shelf. the challenge was that the number of shelves the user wants is also selectable, and this would effect the height, but the heigth also effects how many shelves will fit in the shelves. 

The control flow diagram shows this. 

it is mainly in these three methods 

```ruby 
def shelf_qty_constraint(height, smallest_shelf_size, largest_shelf_size)
    result = []
    
    max = (height-(smallest_shelf_size*2))/smallest_shelf_size
    min = (height/largest_shelf_size)
   
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

def height_suggester(options_array, height, shelf_qty)  

    adj_height_array=[]

       closest = options_array[shelf_qty.to_i].sort.group_by do |item|
        item <=> height
    end
     p closest
    
    
    if closest[0]
        # p closest[0]
        adj_height_array << closest[-1][-1]
        adj_height_array << closest[0][0]    
        if closest[1]
            adj_height_array << closest[1][0]
        end
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
```
The method ```generate_all_combinations``` creates an array of all the possible combinations of shelf heights, in each quantity. 

This data is then used to suggest options for shelf height and quantity to the user that fit within the allowable constraints. 

After debugging all these methods, the rest was straightforward. the quoting calculator was simple. 

The only issue is that I'm going to have to rewrite the row builder because it doen't use loops in the right way so I have to repeat the row building and Ive only done it 6 times, which means I can build a maximum of 6 rows. but it works well enough for MVP. 

I regrettably didn't get time to make a way to add and edit materials, or spend much time making the app look good at all. 










