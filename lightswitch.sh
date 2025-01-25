#!/bin/bash

declare -A FUNCTIONS

# Function for interactive mode
function interactive_mode() {
    echo "Welcome to Lightswitch Interactive Mode. Type 'exit' to quit."
    while true; do
        printf "lightswitch> "
        read -r command
        if [[ "$command" == "exit" ]]; then
            echo "Exiting Lightswitch Interactive Mode."
            break
        fi
        execute_lightswitch "$command"
    done
}

# Function to execute Lightswitch commands
function execute_lightswitch() {
    local command="$1"
    case "$command" in
        print\ *)
            # Print command
            echo "${command#* }"
            ;;
        math\ *)
            # Math command: e.g., math 5+3=result
            local equation=$(echo "$command" | cut -d' ' -f2)
            local lhs=$(echo "$equation" | cut -d'=' -f1)
            local result_var=$(echo "$equation" | cut -d'=' -f2)
            local result=$(echo "$lhs" | bc)
            eval "$result_var=$result"
            ;;
        for\ *)
            # For loop: e.g., for i in 1 2 3; do ... endfor
            local var=$(echo "$command" | awk '{print $2}')
            local items=$(echo "$command" | cut -d' ' -f4-)
            local loop_body=""
            while IFS= read -r loop_line; do
                if [[ "$loop_line" == "endfor" ]]; then
                    break
                fi
                loop_body+="$loop_line"$'\n'
            done
            for item in $items; do
                while IFS= read -r line; do
                    eval "$(echo "$line" | sed "s/\$$var/$item/g")"
                done <<< "$loop_body"
            done
            ;;
        if\ *)
            # If condition: e.g., if $var -eq 10; then ... endif
            local condition="${command#if }"
            condition="${condition% then}"
            local if_body=""
            while IFS= read -r if_line; do
                if [[ "$if_line" == "endif" ]]; then
                    break
                fi
                if_body+="$if_line"$'\n'
            done
            if eval "[[ $condition ]]"; then
                while IFS= read -r line; do
                    eval "$line"
                done <<< "$if_body"
            fi
            ;;
        case\ *)
            # Case statement: e.g., case $var in ... esac
            local var=$(echo "$command" | awk '{print $2}')
            local case_body=""
            while IFS= read -r case_line; do
                if [[ "$case_line" == "esac" ]]; then
                    break
                fi
                case_body+="$case_line"$'\n'
            done
            while IFS= read -r line; do
                eval "$line"
            done <<< "$case_body"
            ;;
        function\ *)
            # Function definition
            local func_name=$(echo "$command" | awk '{print $2}' | tr -d '()')
            local func_body=""
            while IFS= read -r func_line; do
                if [[ "$func_line" == "endfunction" ]]; then
                    break
                fi
                func_body+="$func_line"$'\n'
            done
            FUNCTIONS["$func_name"]="$func_body"
            ;;
        set\ *)
            # Variable assignment, including capturing command output
            local var_name=$(echo "$command" | cut -d' ' -f2)
            local command_to_run=$(echo "$command" | cut -d' ' -f3-)
            eval "$var_name=$(eval "$command_to_run")"
            ;;
        version)
            echo "Lightswitch Interpreter Version 1.0"
            ;;
        curl\ *)
            # Curl: Fetch content from URL
            local url="${command#curl }"
            curl -s "$url"
            ;;
        ping\ *)
            # Ping: Ping a host or IP
            local host="${command#ping }"
            ping -c 4 "$host"
            ;;
        sleep\ *)
            # Sleep: Wait for a specified time
            local time="${command#sleep }"
            sleep "$time"
            ;;
        exec\ *)
            # Exec: Run a Bash command
            local bash_command="${command#exec }"
            bash -c "$bash_command"
            ;;
        while\ *)
            # While loop: e.g., while $condition do ... done
            local condition=$(echo "$command" | cut -d' ' -f2)
            local loop_body=""
            while IFS= read -r line; do
                if [[ "$line" == "done" ]]; then
                    break
                fi
                loop_body+="$line"$'\n'
            done
            while eval "$condition"; do
                eval "$loop_body"
            done
            ;;
        run\ *)
            # Single command execution: lightswitch run "command"
            local cmd="${command#run }"
            execute_lightswitch "$cmd"
            ;;
        help)
            # Help command: Displays a list of commands
            echo "Available Lightswitch Commands:"
            echo "  print <text>         - Print the provided text"
            echo "  math <equation>      - Perform math operations (e.g., math 5+3=result)"
            echo "  for <var> in <list>  - Loop over a list (e.g., for i in 1 2 3)"
            echo "  if <condition> then  - Conditional statement (e.g., if $x -eq 5 then)"
            echo "  case <var> in ... esac - Case statement"
            echo "  function <name> () { ... } - Define a function"
            echo "  set <var> <value>    - Set a variable with a value"
            echo "  version              - Show the version of Lightswitch"
            echo "  curl <url>           - Fetch content from a URL using curl"
            echo "  ping <host>          - Ping a host"
            echo "  sleep <seconds>      - Pause execution for a specified time"
            echo "  exec <command>       - Execute a bash command"
            echo "  while <condition> do ... done - While loop"
            echo "  run <command>        - Run a single Lightswitch command"
            echo "  exit                 - Exit interactive mode"
            ;;
        *)
            # Check if it's a function call
            local func_name=$(echo "$command" | awk '{print $1}')
            if [[ -n "${FUNCTIONS[$func_name]}" ]]; then
                # Execute the function
                local args=$(echo "$command" | cut -d' ' -f2-)
                local func_body="${FUNCTIONS[$func_name]}"
                while IFS= read -r func_line; do
                    eval "$(echo "$func_line" | sed -e "s/\$1/$(echo $args | cut -d' ' -f1)/g" -e "s/\$2/$(echo $args | cut -d' ' -f2)/g")"
                done <<< "$func_body"
            else
                echo "Unknown or unsupported command: $command"
            fi
            ;;
    esac
}

# Main logic
if [[ "$1" == "--interactive" ]]; then
    interactive_mode
else
    if [[ "$1" == "run" ]]; then
        execute_lightswitch "$2"
    else
        while IFS= read -r line || [[ -n "$line" ]]; do
            execute_lightswitch "$line"
        done < "$1"
    fi
fi
