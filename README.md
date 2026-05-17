Based on your actual report and university requirements, here is a professional GitHub `README.md` you can directly copy, paste, and modify for your repository.

# Online Book Shop Management System — 8086 Assembly Language

## CEN-323 Computer Organization & Assembly Language (COAL)

Semester Project developed in **8086 Assembly Language** using **EMU8086**.

This project was developed as part of the **CEN-323 COAL Semester Project Phase 2** at Bahria University under the supervision of **Sir Adnan Jelani**.

---

# Project Overview

The **Online Book Shop Management System** is a menu-driven DOS application that simulates the core functionalities of an online bookstore using low-level Assembly Language programming.

The project demonstrates practical implementation of:

* DOS Interrupts
* Register manipulation
* String handling
* Procedures and modular programming
* Conditional branching
* Arrays and memory addressing
* Billing and arithmetic operations

The system supports both **User** and **Admin** functionalities through a text-based console interface running inside EMU8086.

---

# Features

## User Features

* User Login Authentication
* Browse Book Categories
* Search Books by Serial Number
* Buy Books
* Quantity Selection
* Bill Generation
* Logout System

## Admin Features

* Admin Login
* View Complete Inventory
* Access All Books

## System Features

* Menu-driven Navigation
* DOS Interrupt Based Input/Output
* Modular Procedure-Based Design
* Error Handling
* Billing Calculation
* Screen Clearing & Navigation
* Beginner Friendly Code Structure

---

# Technologies Used

| Technology                | Purpose               |
| ------------------------- | --------------------- |
| 8086 Assembly Language    | Core Programming      |
| EMU8086                   | Emulator & Assembler  |
| DOS Interrupts (INT 21H)  | Input/Output Handling |
| BIOS Interrupts (INT 10H) | Screen Management     |
| GitHub                    | Version Control       |

---

# Assembly Concepts Used

This project implements multiple core Assembly Language concepts:

* Data Segment
* Code Segment
* Stack Segment
* Procedures
* Loops
* Conditional Jumps
* Arrays
* Strings
* Memory Addressing
* Register Operations
* Stack Operations
* ASCII Conversion
* DOS Interrupts
* BIOS Interrupts

---

# DOS Interrupts Used

| Interrupt     | Function            | Purpose             |
| ------------- | ------------------- | ------------------- |
| INT 21H / 01H | Character Input     | Menu Selection      |
| INT 21H / 02H | Character Output    | Display Characters  |
| INT 21H / 09H | String Output       | Print Strings       |
| INT 21H / 0AH | Buffered Input      | Username & Password |
| INT 21H / 4CH | Program Termination | Exit Program        |
| INT 10H / 06H | Scroll Window       | Clear Screen        |
| INT 10H / 02H | Cursor Position     | Reset Cursor        |

---

# Project Modules

## 1. MAIN Procedure

* Initializes data segment
* Displays welcome screen
* Handles main menu navigation

## 2. USER_LOGIN

* Accepts username/password
* Uses buffered string input
* Validates credentials

## 3. ADMIN_LOGIN

* Authenticates administrator
* Displays inventory system

## 4. USER_MENU_PROC

* Handles user menu operations
* Navigates between modules

## 5. CATEGORY_MENU

* Displays categorized books
* Handles category selection

## 6. SEARCH_BOOK

* Searches books using serial number
* Validates input ranges

## 7. BUY_BOOK

* Accepts quantity
* Calculates total bill
* Generates receipt

## 8. PRINT_NUMBER

* Converts integer to ASCII
* Displays calculated totals

## 9. STR_COMPARE

* Performs string comparison
* Used for authentication

---

# Book Categories

## Programming Books

* C Programming
* Python Programming

## Fiction Books

* Harry Potter
* The Alchemist

## Science Books

* Physics Fundamentals
* Basic Chemistry

---

# Project Structure

```bash
CEN323_GXX_OnlineBookShop/
│
├── ONLINE BOOK SHOP MANAGEMENT SYSTEM.asm
├── README.md
├── report/
│   └── Final_Report.pdf
├── screenshots/
│   ├── welcome-screen.png
│   ├── main-menu.png
│   ├── login.png
│   ├── categories.png
│   └── billing.png
└── docs/
```

---

# How to Run the Project

## Requirements

* EMU8086 installed on Windows

EMU8086 Download:
[https://emu8086-microprocessor-emulator.en.lo4d.com/windows](https://emu8086-microprocessor-emulator.en.lo4d.com/windows)

---

# Steps to Execute

1. Open EMU8086
2. Open the `.asm` file
3. Compile the program
4. Run the application
5. Follow the on-screen instructions

---

# Sample Workflow

```text
START
  ↓
Welcome Screen
  ↓
Main Menu
  ↓
User/Admin Login
  ↓
User Menu
  ↓
Categories / Search / Buy
  ↓
Billing System
  ↓
Logout / Exit
```

---

# Testing & Results

The project was tested using:

* Functional Testing
* Boundary Testing
* Negative Testing
* EMU8086 Debugger

## Tested Features

* Login Authentication
* Search Validation
* Billing Arithmetic
* Quantity Validation
* Menu Navigation
* Error Handling

All major functionalities passed successfully.

---

# Challenges Faced

* Register management
* Stack preservation
* DOS interrupt handling
* String comparison debugging
* Array indexing
* Billing arithmetic
* Memory offset handling

---

# Learning Outcomes

Through this project we learned:

* Low-level programming concepts
* DOS interrupt services
* Memory management in 8086
* Procedure-based Assembly programming
* Debugging Assembly code
* Team collaboration using GitHub

---

# Future Improvements

Possible future enhancements include:

* File handling support
* Dynamic inventory system
* Customer database
* Improved UI
* More categories
* Graphical Interface
* Persistent storage

---

# Team Contributions

| Member Name   | Registration Number | Module(s) Owned                            |
| ------------- | ------------------- | ------------------------------------------ |
| Muhammad Umer | 01-135232-071       | MAIN, USER_LOGIN, STR_COMPARE              |
| Ibrahim Saud  | 01-135232-059       | USER_MENU_PROC, CATEGORY_MENU, SEARCH_BOOK |

---

# Course Information

| Course                                            | Instructor   |
| ------------------------------------------------- | ------------ |
| CEN-323 Computer Organization & Assembly Language | Adnan Jelani |

---

# GitHub Repository Naming Format

```bash
CEN323_G<GroupNumber>_OnlineBookShop
```

Example:

```bash
CEN323_G04_OnlineBookShop
```

---

# Important Notes

* Developed strictly in 8086 Assembly Language
* Compatible with EMU8086
* Academic project only
* Follows Bahria University semester project guidelines

---

# References

1. Intel 8086 Programmer’s Manual
2. EMU8086 Documentation
3. DOS Interrupt Reference
4. Ralf Brown Interrupt List

---

# License

This repository is intended for educational and academic purposes only.
