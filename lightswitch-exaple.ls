# Example Lightswitch Script using all available features

# Set variables
set name "Alice"
set age 25
set greeting "Hello"
set x 5
set y 3
set color "blue"

# Print a message
print "$greeting, $name! You are $age years old."

# Math operation: addition
math $x + $y = result
print "The sum of $x and $y is $result."

# Define a function to calculate the square of a number
function square()
    set num $1
    math $num * $num = squared_value
    print "The square of $num is $squared_value."
endfunction

# Call the square function with different arguments
call square 4
call square 7

# Conditional: Check if age is greater than 20
if [ $age -gt 20 ]
    print "$name is older than 20."
endif

# Loop: Repeat an action 3 times
for i in 1 2 3
    print "This is iteration $i"
endfor

# Case statement: Check color
case $color
    red) print "The color is red." ;;
    blue) print "The color is blue." ;;
    green) print "The color is green." ;;
    *) print "Unknown color" ;;
endcase

# Exit message
print "Script execution completed."

