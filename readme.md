

## Purpose and Scope

The aim of this app is to provide accurate quotes for a simple cabinet design, taking inputs for dimensions, materials choice, and functional configuration from the user, and providing a cost, and providing a final price. 

This app is tartgeted at tradesmen and manufactures with a need to generate quotes for small cabinet orders. 

It provides a way to quickly and reliably generate quotes, based on a few inputs from a customer. this saves time for the user, compared to generating quotes manually, meaning that user can get quotes to the customer more quickly, and spend less time on non-billable work. 


## Features


1. The app takes user input to choose from 3 set cabinet depths: 280mm, 380mm, 580mm. This allows the flexibility to quote anything from a small single shelf, to an entire wardrobe. 

2. Preset Shelf height constraints. The app limits shelf heights to intervals of 180mm,280mm, or 380mm to allow standardization of things like the user's cupboard and drawer kits. This is achieved by creating an array of all possible permutations of shelf combinations for every shelf quantity, and then selecting the options closest to the users preferred height, and then specifying the allowable shelf quantities that will fit these heights. 

3. Parts generation. From the constrained cabinet dimensions and shelf quantites, the app will generate an array of hashes corresponding to each piece of the cabinet, specifying length, width and thickness of each piece.

3. Panel Optimisation. - From the part hashes array the app will calculate the minimum number of plywood or other panels required to build the shelves, and output an ordered cut list of pieces. This is done by dividing the panel width (of 1200mm) into rows equal to the cabinet depth (of 280, 380 or 580mm), and looping through the array of pieces, ordered by decreasing length,  adding pieces to each row until the piece lengths add up to the panel length (of 2400mm), before moving on to the next row. In this way the most efficient use of materials can be ensured. The cut list will then specify a ripping width, and cross-cut length, taking out the labour required to determine this manually. 

4. BOM generation, itemised costing and quoting - the app will output an itemised BOM, including QTY and cost for plywood panels, carcasse connecting hardware, shelf support hardware, CNC machining and total piece count. The app also calculates a final price based on a fixed formula(**future versions will include an adjustable mark_up formula**)



# User experience and interaction

The app is very simple to use. Taking inputs for depth, width and height, shelf quantity from the user with a simple prompt, adjusting and confirming these adjustments to suit the constraints mentioned above. Once calculated, the outputs will be displayed to the screen and the user is asked whether or not they would like to save the results to file. 

To install the app 

1. Have ruby installed 
2. Clone repository
```
git clone git@github.com:Kyle46220/Cabinet_Quoting_Terminal_App.git
```
3. cd to repo directory

4. run build.sh script
```
bash build.sh
```
5. cd to dist
 ```
 cd dist
 ```
6. run file 
```
ruby FAB_CABS.rb
```
7. To add a customer name or reference to the file - 
```
ruby FAB_CABS.rb reference_or_customer_name
```
8. Enjoy

## control flow diagram 

<img src="Simple Flow Chart Diagram.jpeg"
alt = "Simple Flow Chart Diagram"
style = "width: 90%;"/>

<img src="Terminal App Flow Chart.jpeg"
alt = "Simple Flow Chart Diagram"
style = "width: 90%;"/>

![Simple Flow Chart](https://drive.google.com/file/d/1mpOWcXPhmR52eWyxqzTESFG1nXol84Qe/view "Simple Flow Chart")
![Comprehensive Flow Chart](https://drive.google.com/file/d/1mhxx3YJgqR4HU7sXeVny3iEoGx1fbX9j/view "Comprehensive Flow Chart")



