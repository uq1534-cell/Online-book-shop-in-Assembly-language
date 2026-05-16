# Online-book-shop-in-Assembly-language
The Online Book Shop Management System is a console-based 8086 Assembly application built for the EMU8086 emulator. It simulates a small bookstore where:

A User can browse books by category, search a book by its serial number, add books to a cart, choose quantity, and generate a bill.
An Admin can log in with a password and view the full inventory.
The program uses only INT 21h DOS interrupts for I/O (no BIOS video tricks, no graphics), making it beginner-friendly and university-grade.
Key design goals:

Modular procedures (PRINT_STR, READ_CHAR, CLEAR_SCREEN, NEW_LINE, etc.)
Menu-driven navigation with safe return to main menu
Simple billing arithmetic using 16-bit registers
Hard-coded inventory of 6 books across 3 categories
