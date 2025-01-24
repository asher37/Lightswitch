
# Lightswitch - A Simple Scripting Language

Lightswitch is a simple scripting language that supports common operations like string manipulation, mathematical operations, logical operations, and file I/O.

## Installation

To install Lightswitch, follow these steps:

1. Download the `lightswitch.sh` and `lightswitch.1` files.
2. Run the installation script with root privileges:
    ```bash
    sudo ./install.sh
    ```
3. Once installed, you can run Lightswitch with:
    ```bash
    lightswitch --interactive
    ```

### Man Pages

You can view the man page for Lightswitch by running:
```bash
man lightswitch
```

## Usage

### Command-Line Usage

You can run Lightswitch in interactive mode or execute a script file:
- **Interactive Mode**:
    ```bash
    lightswitch --interactive
    ```
- **Script File**:
    ```bash
    lightswitch <script_file>.ls
    ```

### Built-in Commands

- **concat <str1> <str2>**: Concatenate two strings.
- **length <str>**: Get the length of a string.
- **substr <str> <start> <length>**: Extract a substring from a string.
- **readfile <file>**: Read content from a file.
- **writefile <file> <content>**: Write content to a file.
- **array <arr_name>**: Create an empty array.
- **arraylen <arr_name>**: Get the length of an array.
- **arrayget <arr_name> <index>**: Get an element from the array.
- **arrayset <arr_name> <index> <value>**: Set an element in the array.
- **sqrt <num>**: Calculate the square root of a number.
- **pow <base> <exp>**: Raise a number to a power.
- **random <min> <max>**: Generate a random number between min and max.
- **and <val1> <val2>**: Logical AND operation (1 or 0).
- **or <val1> <val2>**: Logical OR operation (1 or 0).
- **not <val>**: Logical NOT operation (1 or 0).
- **exit <status>**: Exit the program with a status code.
- **status**: Show the exit status of the last command.
- **help**: Show this help message.

### Examples

- Concatenate two strings:
    ```bash
    concat Hello World
    ```
- Get the length of a string:
    ```bash
    length Hello
    ```
- Perform a math operation:
    ```bash
    math 3 + 2 = sum
    ```
- Read a file:
    ```bash
    readfile myfile.txt
    ```

## License

Lightswitch is licensed under the MIT License. See LICENSE for more details.

