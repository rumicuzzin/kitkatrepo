# MTRX2700 Assembly Language for STM32F3 Discovery Board

## Project Overview

This repository contains our implementation of the Assembly Language exercises for the MTRX2700 Mechatronics 2 unit at the University of Sydney. The project explores fundamental microcontroller concepts through assembly language programming on the STM32F3 Discovery Board, focusing on memory operations, digital I/O, serial communication, and hardware timers.

---

## Team Members

- **Joshua Kim** - Exercise 1: Memory and Pointers, Exercise 3: Serial Communication
- **Kelian Landry** - Exercise 2: Digital I/O, Exercise 4: Hardware Timers
- **Willem Rumi** - Excercise 1: Memory and Pointers, Exercise 3: Serial Communication, Documentation
- **Alex** - Exercise 2: Digital I/O, Exercise 4: Hardware Timers, Exercise 5: Integration

---

## Project Structure

The repository is organized by exercise, with each containing the relevant assembly source files:

* **Ex1** - Memory and Pointers implementations
  * **EX1A** - Case conversion function
  * **EX1B** - Palindrome detection function
  * **EX1C** - Caesar cipher implementation
* **Ex2_task_abc** - Digital I/O implementations
* **Ex2c_Kelian_version** - Alternative implementation of Exercise 2C
* **Ex3** - Serial communication functions
* **Ex4** - Hardware timer implementations
* **Ex5** - Integration exercise with board1 and board2 code
* **Minutes** - Meeting minutes and agendas

---

## Module Descriptions

### Exercise 1: Memory and Pointers

Implementation of string manipulation functions in assembly language:

#### EX1A: String Case Conversion
- Takes a string in memory and converts characters based on register R2's state
- If R2 = 0, converts uppercase to lowercase
- If R2 = 1, converts lowercase to uppercase

#### EX1B: Palindrome Detection Function
- Checks if a string reads the same forwards and backwards
- Returns result in register R0 (1 if palindrome, 0 if not)

#### EX1C: Caesar Cipher Implementation
- Shifts letters in a string by a given value (positive or negative)
- Handles wrap-around for alphabetic characters
- Preserves non-alphabetic characters

### Exercise 2: Digital I/O

Functions for controlling the Discovery board's LEDs and button:

- **LED Pattern Control**: Set LEDs to display specific patterns using bitmasks
- **Button Input**: Read user button presses and update LED display accordingly
- **State Transitions**: Toggle between incrementing and decrementing LED patterns
- **Character Analysis**: Count vowels and consonants in strings and visualize on LEDs

### Exercise 3: Serial Communication

UART communication modules:

- **String Transmission**: Send strings with terminating characters
- **String Reception**: Receive strings into buffer until terminating character
- **Clock Speed Management**: Adjust clock speed while maintaining correct baud rate
- **Loopback Functionality**: Echo received characters back on the same UART
- **Port Forwarding**: Connect two UARTs to relay characters between them

### Exercise 4: Hardware Timers

Timer functionality:

- **Microsecond Delay**: Create precise delay functions using hardware timer
- **Prescaler Configuration**: Select appropriate prescaler values for different time periods
- **Auto-reload Preload**: Use TIMx_ARR with ARPE=1 for accurate hardware-managed delays

### Exercise 5: Integration

Full system integration combining all previous exercises:

- **Two-board Communication**: Connect PC to first board via USART1, then to second board
- **Palindrome Detection**: First board checks if input is a palindrome
- **Caesar Cipher**: Apply cipher to palindrome messages before forwarding
- **LED Visualization**: Second board displays vowel/consonant counts of received message

---

## How to Use

### Prerequisites

- STM32CubeIDE
- STM32F3 Discovery Board
- USB Mini-B cables
- Terminal software (e.g., PuTTY, Tera Term) for UART testing

### Setup Instructions

1. Clone this repository
2. Open STM32CubeIDE
3. Import the project: File → Import → Existing Projects into Workspace
4. Select the repository root directory
5. Build the project

### Running Individual Exercises

Each exercise can be loaded and run separately:

1. Right-click on the specific exercise folder in Project Explorer
2. Select "Build Project"
3. Connect the STM32F3 Discovery board via USB
4. Click "Debug" to flash the program and run

### Testing Serial Communication

For exercises requiring UART communication:

1. Connect ST-LINK USB for programming
2. Connect UART pins to a USB-to-serial adapter or directly to another board
3. Configure terminal software with:
   - Baud rate: 115200
   - Data bits: 8
   - Parity: None
   - Stop bits: 1
   - Flow control: None

---

## Testing Results

### Exercise 1
- Case conversion successfully transforms text based on register state
- Palindrome detection correctly identifies strings like "racecar"
- Caesar cipher shifts "dog" by +1 correctly to "eph" and can decode back

### Exercise 2
- LEDs display patterns corresponding to input bitmasks
- Button press detection is reliable with debouncing implemented
- LED state transitions occur correctly between on/off modes
- Character analysis counts vowels and consonants accurately

### Exercise 3
- String transmission and reception works with terminating characters
- Communication maintained after clock speed changes
- Loopback functionality successfully echoes received characters
- Port forwarding works between UART and UART4

### Exercise 4
- Delay function accurately creates delays in microsecond ranges
- Different prescaler values selected appropriately for time periods
- Auto-reload preload creates stable timing for LED blinking

### Exercise 5
- End-to-end system communication works between boards
- Palindrome detection and Caesar cipher encoding function correctly
- LED visualization shows the correct vowel and consonant counts

---

## Contribution Timeline

Our project was developed over several weeks, with key milestones:

- **Week 1** (Feb 25): Initial setup, Git repository creation, IDE installation
- **Week 2** (Mar 4): Role assignment, started working on exercises 1-3
- **Week 3** (Mar 11): Continued work on exercises 1-3, started exercise 4
- **Week 4** (Mar 18): Completed exercises 1-4, planned exercise 5
- **Week 5** (Mar 24-25): Integration testing, documentation, and final preparations

---

## References

- STM32F303xC Reference Manual
- Lecture materials from MTRX2700
- ARM Cortex-M4 Assembly Language Programming