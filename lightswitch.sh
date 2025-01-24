#!/bin/bash
# Lightswitch Interpreter with interactive mode

function help_command {
    cat << EOF
Lightswitch - A simple scripting language

Usage:
  --interactive    Start Lightswitch in interactive mode
  <script_file>     Run a Lightswitch script

Built-in Commands:
  concat <str1> <str2>    Concatenate two strings
  length <str>            Get the length of a string
  substr <str> <start> <length>   Get a substring
  readfile <file>         Read content of a file
  writefile <file> <content>   Write content to a file
  array <arr_name>        Create an empty array
  arraylen <arr_name>     Get the length of an array
  arrayget <arr_name> <index>   Get an element from the array
  arrayset <arr_name> <index> <value>   Set an element in the array
  sqrt <num>              Calculate the square root of a number
  pow <base> <exp>        Raise a number to a power
  random <min> <max>      Generate a random number between min and max
  and <val1> <val2>       Logical AND operation (1 or 0)
  or <val1> <val2>        Logical OR operation (1 or 0)
  not <val>               Logical NOT operation (1 or 0)
  exit <status>           Exit the program with a status code
  status                 Show the exit status of the last command
  help                   Show this help message

Examples:
  concat Hello World
  length Hello
  math 3 + 2 = sum
  readfile myfile.txt

EOF
}



# Function to execute commands
execute_command() {
    local line="$1"

    # Ignore comments (lines starting with #)
    [[ "$line" =~ ^# ]] && return

    # Trim whitespace and convert to lowercase
    line=$(echo "$line" | sed 's/^[ \t]*//;s/[ \t]*$//' | awk '{print tolower($0)}')

    case "$line" in
        concat*)
            str1=$(echo "$line" | awk '{print $2}')
            str2=$(echo "$line" | awk '{print $3}')
            echo "$str1$str2"
            ;;
        length*)
            str=$(echo "$line" | awk '{print $2}')
            echo "${#str}"
            ;;
        substr*)
            str=$(echo "$line" | awk '{print $2}')
            start=$(echo "$line" | awk '{print $3}')
            length=$(echo "$line" | awk '{print $4}')
            echo "${str:$start:$length}"
            ;;
        readfile*)
            file=$(echo "$line" | awk '{print $2}')
            cat "$file"
            ;;
        writefile*)
            file=$(echo "$line" | awk '{print $2}')
            content=$(echo "$line" | awk '{print $3}')
            echo "$content" > "$file"
            ;;
	help*)
		help_command
		;;
        array*)
            arr=$(echo "$line" | awk '{print $2}')
            eval "$arr=()"
            ;;
        arraylen*)
            arr=$(echo "$line" | awk '{print $2}')
            eval "echo \${#$arr[@]}"
            ;;
        arrayget*)
            arr=$(echo "$line" | awk '{print $2}')
            index=$(echo "$line" | awk '{print $3}')
            eval "echo \${$arr[$index]}"
            ;;
        arrayset*)
            arr=$(echo "$line" | awk '{print $2}')
            index=$(echo "$line" | awk '{print $3}')
            value=$(echo "$line" | awk '{print $4}')
            eval "$arr[$index]=$value"
            ;;
        sqrt*)
            num=$(echo "$line" | awk '{print $2}')
            echo "scale=2; sqrt($num)" | bc
            ;;
        pow*)
            base=$(echo "$line" | awk '{print $2}')
            exp=$(echo "$line" | awk '{print $3}')
            echo "$((base**exp))"
            ;;
        random*)
            min=$(echo "$line" | awk '{print $2}')
            max=$(echo "$line" | awk '{print $3}')
            echo $(( ( RANDOM % (max - min + 1) ) + min ))
            ;;
        and*)
            val1=$(echo "$line" | awk '{print $2}')
            val2=$(echo "$line" | awk '{print $3}')
            if [ "$val1" -eq 1 ] && [ "$val2" -eq 1 ]; then
                echo "1"
            else
                echo "0"
            fi
            ;;
        or*)
            val1=$(echo "$line" | awk '{print $2}')
            val2=$(echo "$line" | awk '{print $3}')
            if [ "$val1" -eq 1 ] || [ "$val2" -eq 1 ]; then
                echo "1"
            else
                echo "0"
            fi
            ;;
        not*)
            val=$(echo "$line" | awk '{print $2}')
            if [ "$val" -eq 0 ]; then
                echo "1"
            else
                echo "0"
            fi
            ;;
        exit*)
            status=$(echo "$line" | awk '{print $2}')
            exit $status
            ;;
        status)
            echo $?
            ;;
        *)
            echo "Unknown or unsupported command: $line"
            ;;
    esac
}

# Interactive mode
interactive_mode() {
    echo "Welcome to Lightswitch Interactive Mode!"
    echo "Type 'exit' to quit."
    
    while true; do
        # Display a prompt
        echo -n "lightswitch> "
        
        # Read user input
        read -r user_input
        
        # Exit if the user types 'exit'
        if [[ "$user_input" == "exit" ]]; then
            echo "Exiting Lightswitch interactive mode."
            break
        fi
        
        # Process the entered command
        execute_command "$user_input"
    done
}

# Check if we are in interactive mode
if [[ "$1" == "--interactive" || -z "$1" ]]; then
    interactive_mode
else
    # Run as a script
    for script_file in "$@"; do
        while IFS= read -r line; do
            execute_command "$line"
        done < "$script_file"
    done
fi

