# Lightswitch Interpreter

Lightswitch is a lightweight, interactive scripting language interpreter designed for simple command execution with support for loops, conditionals, functions, and more. It is designed to be easy to use while also supporting powerful functionality.

## Features

- **Print Command**: print "Hello, World!"
- **Math Command**: math 5+3=result
- **For Loop**: for i in 1 2 3; do ... endfor
- **If Condition**: if $var -eq 10; then ... endif
- **Case Statement**: case $var in ... esac
- **Functions**: Define custom functions with function func_name () { ... }
- **Set Variables**: set var value
- **Version**: Display the current version with version
- **Curl**: Fetch content from a URL with curl <url>
- **Ping**: Ping a host or IP with ping <host>
- **Sleep**: Pause execution for a given time with sleep <seconds>
- **Exec**: Execute a bash command with exec <command>
- **While Loop**: while <condition> do ... done
- **Run**: Execute a single Lightswitch command with run "<command>"
- **Help**: Display help for available commands with help

## Installation

1. Clone or download the repository.
2. Make the script executable:
   `chmod +x lightswitch`

## Usage

### Interactive Mode:
To start Lightswitch in interactive mode, run the following command:

`lightswitch --interactive`

### Run a Single Command:
You can also run a single Lightswitch command using the following syntax:

`lightswitch run "print Hello, World!"`

LightSwitch is under the MIT licence. See LICENCE for more info.
