;==========================================================
;  ONLINE BOOK SHOP MANAGEMENT SYSTEM  (EXTENDED v2.0)
;  Platform : EMU8086 (8086 Assembly, DOS INT 21h)
;  Authors  : MUHAMMAD UMER & IBRAHIM SAUD
;==========================================================

.MODEL SMALL
.STACK 200H          ; increased stack for deeper call nesting

;==========================================================
;                    DATA SEGMENT
;==========================================================
.DATA

;----------------------------------------------------------
; WELCOME / MAIN MENU STRINGS  (unchanged)
;----------------------------------------------------------
welcome_msg  db 0Dh,0Ah
             db "==================================================",0Dh,0Ah
             db "        ONLINE BOOK SHOP MANAGEMENT SYSTEM       ",0Dh,0Ah
             db "==================================================",0Dh,0Ah
             db "        Welcome to BRO'S UNITED BOOK STORE       ",0Dh,0Ah
             db "==================================================",0Dh,0Ah,0Dh,0Ah
             db "         Press any key to continue...$"

main_menu    db 0Dh,0Ah
             db "--------------- MAIN MENU ---------------",0Dh,0Ah
             db "  1. User  Login",0Dh,0Ah
             db "  2. Admin Login",0Dh,0Ah
             db "  3. Exit",0Dh,0Ah
             db "-----------------------------------------",0Dh,0Ah
             db "  Enter your choice : $"

;----------------------------------------------------------
; NEW: ADMIN MENU STRING
;----------------------------------------------------------
admin_menu   db 0Dh,0Ah
             db "------------- ADMIN MENU ----------------",0Dh,0Ah
             db "  1. View All Books",0Dh,0Ah
             db "  2. Add New Book",0Dh,0Ah
             db "  3. Update Book Quantity",0Dh,0Ah
             db "  4. Logout",0Dh,0Ah
             db "-----------------------------------------",0Dh,0Ah
             db "  Enter your choice : $"

;----------------------------------------------------------
; USER MENU STRING  (unchanged)
;----------------------------------------------------------
user_menu    db 0Dh,0Ah
             db "--------------- USER MENU ---------------",0Dh,0Ah
             db "  1. View All Books",0Dh,0Ah
             db "  2. Search Book by Serial No.",0Dh,0Ah
             db "  3. Buy Book",0Dh,0Ah
             db "  4. Logout",0Dh,0Ah
             db "-----------------------------------------",0Dh,0Ah
             db "  Enter your choice : $"

;----------------------------------------------------------
; LOGIN STRINGS  (unchanged)
;----------------------------------------------------------
prompt_user  db 0Dh,0Ah,"Enter Username (max 9 chars) : $"
prompt_pass  db 0Dh,0Ah,"Enter Password (max 9 chars) : $"

user_pass    db "umer$"
admin_pass   db "ibrahim$"

buf_user     db 10, 0, 10 dup('$')
buf_pass     db 10, 0, 10 dup('$')

;----------------------------------------------------------
; STATUS / ERROR STRINGS  (unchanged)
;----------------------------------------------------------
err_choice   db 0Dh,0Ah,"!! Invalid Choice. Try again. !!",0Dh,0Ah,"$"
err_login    db 0Dh,0Ah,"!! Wrong Username or Password !!",0Dh,0Ah,"$"
ok_login     db 0Dh,0Ah,">> Login Successful <<",0Dh,0Ah,"$"
bye_msg      db 0Dh,0Ah,"Goodbye! Program terminated.",0Dh,0Ah,"$"
press_any    db 0Dh,0Ah,"Press any key to continue...$"

;----------------------------------------------------------
; BILLING STRINGS  (unchanged)
;----------------------------------------------------------
buy_msg      db 0Dh,0Ah,"Enter book serial no to buy : $"
qty_msg      db 0Dh,0Ah,"Enter quantity (1-9)        : $"
bill_hdr     db 0Dh,0Ah,"======== BILL RECEIPT ========",0Dh,0Ah,"$"
bill_book    db "  Book  : $"
bill_qty     db 0Dh,0Ah,"  Qty   : $"
bill_unit    db 0Dh,0Ah,"  Price : $"
bill_total   db 0Dh,0Ah,"  TOTAL : $"
bill_end     db 0Dh,0Ah,"==============================",0Dh,0Ah,"$"
thank_msg    db 0Dh,0Ah,"Thank you for shopping at Bro's United BookWorld!",0Dh,0Ah,"$"

;----------------------------------------------------------
; SEARCH STRINGS
;----------------------------------------------------------
search_msg   db 0Dh,0Ah,"Enter book serial no (1-20) : $"
search_found db 0Dh,0Ah,"=== Book Found ===",0Dh,0Ah,"$"
search_nf    db 0Dh,0Ah,"!! Book NOT Found !!",0Dh,0Ah,"$"

;----------------------------------------------------------
; NEW: ADD BOOK PROMPT STRINGS
;----------------------------------------------------------
add_title_msg  db 0Dh,0Ah,"Enter Book Title  (max 29 chars): $"
add_author_msg db 0Dh,0Ah,"Enter Author Name (max 19 chars): $"
add_price_msg  db 0Dh,0Ah,"Enter Price (1-9999 RS)         : $"
add_qty_msg    db 0Dh,0Ah,"Enter Stock Quantity (1-99)     : $"
add_ok_msg     db 0Dh,0Ah,">> Book Added Successfully! <<",0Dh,0Ah,"$"
max_books_msg  db 0Dh,0Ah,"!! Maximum 20 books reached. Cannot add more. !!",0Dh,0Ah,"$"

;----------------------------------------------------------
; NEW: STOCK MANAGEMENT STRINGS
;----------------------------------------------------------
out_of_stock_msg db 0Dh,0Ah,"!! OUT OF STOCK !!",0Dh,0Ah,"$"
low_stock_msg    db 0Dh,0Ah,"!! Sorry! Only $"
low_stock_msg2   db " books available. !!",0Dh,0Ah,"$"
stock_ok_msg     db 0Dh,0Ah,"Stock updated successfully.",0Dh,0Ah,"$"
upd_serial_msg   db 0Dh,0Ah,"Enter serial no to update stock : $"
upd_newqty_msg   db 0Dh,0Ah,"Enter new stock quantity (0-99) : $"

;----------------------------------------------------------
; DISPLAY HELPER STRINGS
;----------------------------------------------------------
disp_hdr     db 0Dh,0Ah
             db "==========  BOOK INVENTORY  ==========",0Dh,0Ah
             db " No.  Title                  Price  Stock",0Dh,0Ah
             db "---------------------------------------",0Dh,0Ah,"$"
disp_serial  db "  $"           ; filled before print
disp_dot     db ".  $"
disp_price   db "  RS $"
disp_stock   db "  Stock: $"
disp_nl      db 0Dh,0Ah,"$"
disp_dashes  db "---------------------------------------",0Dh,0Ah,"$"

str_title_lbl  db "  Title  : $"
str_author_lbl db "  Author : $"
str_price_lbl  db "  Price  : RS $"
str_stock_lbl  db "  Stock  : $"
str_rs         db " RS",0Dh,0Ah,"$"

;----------------------------------------------------------
; NEW: RUNTIME BOOK DATABASE
; MAX_BOOKS = 20
; Each title  : 30 bytes  (29 chars + 0Dh terminator)
; Each author : 20 bytes  (19 chars + 0Dh terminator)
; Each price  : 1 word (DW)
; Each qty    : 1 byte (DB)
;----------------------------------------------------------
MAX_BOOKS    equ 20

; ---- title array: 20 slots x 30 bytes each = 600 bytes ----
book_titles  db "Let Us C              ",0Dh,7 dup(' ')    ; slot 0
             db "C++ Primer            ",0Dh,7 dup(' ')    ; slot 1
             db "Harry Potter          ",0Dh,7 dup(' ')    ; slot 2
             db "The Alchemist         ",0Dh,7 dup(' ')    ; slot 3
             db "A Brief History       ",0Dh,7 dup(' ')    ; slot 4
             db "Cosmos                ",0Dh,7 dup(' ')    ; slot 5
             db 14 dup(30 dup(' '))                        ; slots 6-19 (empty)

; ---- author array: 20 slots x 20 bytes each = 400 bytes ----
book_authors db "Y. Kanetkar       ",0Dh,' '   ; slot 0
             db "Lippman           ",0Dh,' '   ; slot 1
             db "J.K. Rowling      ",0Dh,' '   ; slot 2
             db "Paulo Coelho      ",0Dh,' '   ; slot 3
             db "S. Hawking        ",0Dh,' '   ; slot 4
             db "Carl Sagan        ",0Dh,' '   ; slot 5
             db 14 dup(20 dup(' '))             ; slots 6-19 (empty)

; ---- price array: 20 words ----
book_prices  dw 250, 400, 500, 300, 450, 350
             dw 14 dup(0)            ; slots 6-19 zeroed

; ---- quantity/stock array: 20 bytes ----
book_quantities db 8, 5, 10, 6, 4, 7
                db 14 dup(0)         ; slots 6-19 zeroed

; ---- total books counter ----
total_books  db 6                   ; starts at 6 (pre-loaded books)

;----------------------------------------------------------
; TEMP INPUT BUFFERS FOR ADD BOOK
; using DOS 0Ah format: byte0=max, byte1=actual, rest=data
;----------------------------------------------------------
inp_title    db 30, 0, 30 dup('$')  ; title input buffer
inp_author   db 20, 0, 20 dup('$')  ; author input buffer
inp_price    db 5,  0,  5 dup('$')  ; price  input buffer (up to 4 digits)
inp_qty_add  db 3,  0,  3 dup('$')  ; qty    input buffer (up to 2 digits)

;----------------------------------------------------------
; TEMP WORKING VARIABLES
;----------------------------------------------------------
total        dw 0                   ; billing total
cur_book_idx db 0                   ; current book index (0-based)

;==========================================================
;                    CODE SEGMENT
;==========================================================
.CODE

;==========================================================
;  MAIN
;==========================================================
MAIN PROC
        MOV AX, @DATA
        MOV DS, AX

        CALL CLEAR_SCREEN
        LEA  DX, welcome_msg
        CALL PRINT_STR
        CALL READ_CHAR

MAIN_LOOP:
        CALL CLEAR_SCREEN
        LEA  DX, main_menu
        CALL PRINT_STR
        CALL READ_CHAR

        CMP AL, '1'
        JE  DO_USER
        CMP AL, '2'
        JE  DO_ADMIN
        CMP AL, '3'
        JE  DO_EXIT

        LEA  DX, err_choice
        CALL PRINT_STR
        CALL PAUSE
        JMP  MAIN_LOOP

DO_USER:
        CALL USER_LOGIN
        JMP  MAIN_LOOP
DO_ADMIN:
        CALL ADMIN_LOGIN
        JMP  MAIN_LOOP
DO_EXIT:
        LEA  DX, bye_msg
        CALL PRINT_STR
        MOV  AH, 4Ch
        INT  21h
MAIN ENDP

;==========================================================
;  USER_LOGIN  (unchanged logic, display now uses loop)
;==========================================================
USER_LOGIN PROC
        CALL CLEAR_SCREEN
        LEA  DX, prompt_user
        CALL PRINT_STR
        LEA  DX, buf_user
        CALL READ_STR

        LEA  DX, prompt_pass
        CALL PRINT_STR
        LEA  DX, buf_pass
        CALL READ_STR

        LEA  SI, buf_pass + 2
        LEA  DI, user_pass
        CALL STR_COMPARE
        JNE  UL_FAIL

        LEA  DX, ok_login
        CALL PRINT_STR
        CALL PAUSE
        CALL USER_MENU_PROC
        RET
UL_FAIL:
        LEA  DX, err_login
        CALL PRINT_STR
        CALL PAUSE
        RET
USER_LOGIN ENDP

;==========================================================
;  ADMIN_LOGIN  (now launches ADMIN_MENU instead of
;               just showing books)
;==========================================================
ADMIN_LOGIN PROC
        CALL CLEAR_SCREEN
        LEA  DX, prompt_user
        CALL PRINT_STR
        LEA  DX, buf_user
        CALL READ_STR

        LEA  DX, prompt_pass
        CALL PRINT_STR
        LEA  DX, buf_pass
        CALL READ_STR

        LEA  SI, buf_pass + 2
        LEA  DI, admin_pass
        CALL STR_COMPARE
        JNE  AL_FAIL

        LEA  DX, ok_login
        CALL PRINT_STR
        CALL PAUSE
        CALL ADMIN_MENU_NEW           ; <-- NEW: full admin menu
        RET
AL_FAIL:
        LEA  DX, err_login
        CALL PRINT_STR
        CALL PAUSE
        RET
ADMIN_LOGIN ENDP

;==========================================================
;  NEW: ADMIN_MENU
;  Loops showing admin options until admin picks Logout
;==========================================================
ADMIN_MENU_NEW PROC
AM_LOOP:
        CALL CLEAR_SCREEN
        LEA  DX, admin_menu
        CALL PRINT_STR
        CALL READ_CHAR

        CMP AL, '1'
        JE  AM_VIEW
        CMP AL, '2'
        JE  AM_ADD
        CMP AL, '3'
        JE  AM_UPD
        CMP AL, '4'
        JE  AM_OUT

        LEA  DX, err_choice
        CALL PRINT_STR
        CALL PAUSE
        JMP  AM_LOOP

AM_VIEW:
        CALL DISPLAY_BOOKS         ; loop-based full inventory
        CALL PAUSE
        JMP  AM_LOOP
AM_ADD:
        CALL ADD_BOOK              ; add a new book at runtime
        JMP  AM_LOOP
AM_UPD:
        CALL UPDATE_STOCK          ; update existing book qty
        JMP  AM_LOOP
AM_OUT:
        RET
ADMIN_MENU_NEW ENDP

;==========================================================
;  USER_MENU_PROC
;==========================================================
USER_MENU_PROC PROC
UM_LOOP:
        CALL CLEAR_SCREEN
        LEA  DX, user_menu
        CALL PRINT_STR
        CALL READ_CHAR

        CMP AL, '1'
        JE  UM_VIEW
        CMP AL, '2'
        JE  UM_SEARCH
        CMP AL, '3'
        JE  UM_BUY
        CMP AL, '4'
        JE  UM_OUT

        LEA  DX, err_choice
        CALL PRINT_STR
        CALL PAUSE
        JMP  UM_LOOP

UM_VIEW:
        CALL DISPLAY_BOOKS
        CALL PAUSE
        JMP  UM_LOOP
UM_SEARCH:
        CALL SEARCH_BOOK
        JMP  UM_LOOP
UM_BUY:
        CALL BUY_BOOK
        JMP  UM_LOOP
UM_OUT:
        RET
USER_MENU_PROC ENDP

;==========================================================
;  NEW: DISPLAY_BOOKS
;  Loop-based display of ALL books currently in the array.
;  Shows: serial no, title, price, stock
;
;  Register usage:
;    CX  = loop counter (total_books)
;    BX  = current index (0-based)
;    SI  = byte offset into arrays
;==========================================================
DISPLAY_BOOKS PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI

        CALL CLEAR_SCREEN
        LEA  DX, disp_hdr
        CALL PRINT_STR

        ; load total books into CX for LOOP instruction
        MOV  BL, total_books      ; BL = number of books
        MOV  BH, 0
        MOV  CX, BX              ; CX = loop count

        CMP  CX, 0
        JE   DB_DONE             ; no books? skip loop

        MOV  BX, 0               ; BX = current book index (0-based)

DB_LOOP:
        ; ---- print serial number (BX+1, human readable) ----
        PUSH CX
        MOV  AX, BX
        INC  AX                  ; display as 1-based
        CALL PRINT_NUMBER        ; prints the number

        LEA  DX, disp_dot        ; ".  "
        CALL PRINT_STR

        ; ---- print title ----
        ; title slot offset = BX * 30
        MOV  AX, BX
        MOV  CX, 30
        MUL  CX                  ; AX = BX * 30
        MOV  SI, AX
        LEA  DX, book_titles
        ADD  DX, SI              ; DX = &book_titles[BX*30]
        CALL PRINT_STR_CR        ; print until 0Dh

        ; ---- print price label ----
        LEA  DX, disp_price      ; "  RS "
        CALL PRINT_STR

        ; ---- print price value ----
        ; price slot offset = BX * 2 (DW array)
        MOV  AX, BX
        SHL  AX, 1               ; AX = BX * 2
        MOV  SI, AX
        MOV  AX, book_prices[SI]
        CALL PRINT_NUMBER

        ; ---- print stock label ----
        LEA  DX, disp_stock      ; "  Stock: "
        CALL PRINT_STR

        ; ---- print stock value ----
        MOV  AL, book_quantities[BX]
        MOV  AH, 0
        CALL PRINT_NUMBER

        ; ---- newline ----
        LEA  DX, disp_nl
        CALL PRINT_STR

        INC  BX                  ; next book
        POP  CX
        LOOP DB_LOOP             ; decrement CX, jump if CX != 0

DB_DONE:
        LEA  DX, disp_dashes
        CALL PRINT_STR

        POP  SI
        POP  DX
        POP  CX
        POP  BX
        POP  AX
        RET
DISPLAY_BOOKS ENDP

;==========================================================
;  NEW: PRINT_STR_CR
;  Prints a string from DS:DX until 0Dh (carriage return)
;  is found. Used for title/author strings which use 0Dh
;  as their terminator (not $).
;
;  Input  : DX = offset of string start
;  Clobbers: AX, SI (saved internally)
;==========================================================
PRINT_STR_CR PROC
        PUSH SI
        PUSH AX

        MOV  SI, DX              ; SI = pointer to string

PSC_LOOP:
        MOV  AL, [SI]            ; load next byte
        CMP  AL, 0Dh             ; carriage return = end?
        JE   PSC_DONE
        CMP  AL, ' '             ; also stop at first padding space
                                 ; after actual content? No — print all.
        MOV  DL, AL
        MOV  AH, 02h
        INT  21h                 ; print the character
        INC  SI
        JMP  PSC_LOOP

PSC_DONE:
        POP  AX
        POP  SI
        RET
PRINT_STR_CR ENDP

;==========================================================
;  NEW: ADD_BOOK
;  Admin enters title, author, price, quantity.
;  Stored into the runtime arrays at index = total_books.
;
;  Data layout (0-based index = IDX):
;    title  stored at book_titles  + IDX*30
;    author stored at book_authors + IDX*20
;    price  stored at book_prices  + IDX*2
;    qty    stored at book_quantities + IDX
;==========================================================
ADD_BOOK PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        PUSH DI

        ; ---- check if we already have 20 books ----
        MOV  AL, total_books
        CMP  AL, MAX_BOOKS
        JB   AB_OK               ; below 20, we can add

        LEA  DX, max_books_msg
        CALL PRINT_STR
        CALL PAUSE
        JMP  AB_EXIT

AB_OK:
        CALL CLEAR_SCREEN

        ; ---- store current index in BX ----
        MOV  BL, total_books
        MOV  BH, 0               ; BX = new book index

        ; ==========================================
        ; STEP 1: get title from admin
        ; ==========================================
        LEA  DX, add_title_msg
        CALL PRINT_STR
        LEA  DX, inp_title
        CALL READ_STR            ; result in inp_title+2..

        ; copy from inp_title+2 into book_titles[BX*30]
        ; destination offset = BX * 30
        MOV  AX, BX
        MOV  CX, 30
        MUL  CX                  ; AX = BX * 30
        MOV  DI, AX              ; DI = destination offset
        LEA  SI, inp_title + 2   ; SI = source (typed chars)

        ; copy up to 29 chars or until 0Dh
        MOV  CX, 29
AB_CP_TITLE:
        MOV  AL, [SI]
        CMP  AL, 0Dh
        JE   AB_TITLE_DONE
        MOV  book_titles[DI], AL
        INC  SI
        INC  DI
        LOOP AB_CP_TITLE
AB_TITLE_DONE:
        MOV  book_titles[DI], 0Dh ; write 0Dh terminator

        ; ==========================================
        ; STEP 2: get author from admin
        ; ==========================================
        LEA  DX, add_author_msg
        CALL PRINT_STR
        LEA  DX, inp_author
        CALL READ_STR

        ; destination offset = BX * 20
        MOV  AX, BX
        MOV  CX, 20
        MUL  CX                  ; AX = BX * 20
        MOV  DI, AX
        LEA  SI, inp_author + 2

        MOV  CX, 19
AB_CP_AUTHOR:
        MOV  AL, [SI]
        CMP  AL, 0Dh
        JE   AB_AUTHOR_DONE
        MOV  book_authors[DI], AL
        INC  SI
        INC  DI
        LOOP AB_CP_AUTHOR
AB_AUTHOR_DONE:
        MOV  book_authors[DI], 0Dh

        ; ==========================================
        ; STEP 3: get price (typed as digits ? convert)
        ; ==========================================
        LEA  DX, add_price_msg
        CALL PRINT_STR
        LEA  DX, inp_price
        CALL READ_STR

        LEA  SI, inp_price + 2
        CALL ATOI                ; convert ASCII string ? AX (number)

        ; store in book_prices[BX*2]
        MOV  SI, BX
        SHL  SI, 1               ; SI = BX * 2 (word offset)
        MOV  book_prices[SI], AX ; store price word
        ; ==========================================
        ; STEP 4: get quantity
        ; ==========================================
        LEA  DX, add_qty_msg
        CALL PRINT_STR
        LEA  DX, inp_qty_add
        CALL READ_STR

        LEA  SI, inp_qty_add + 2
        CALL ATOI                ; AX = quantity number

        ; store in book_quantities[BX]
        MOV  book_quantities[BX], AL

        ; ==========================================
        ; STEP 5: increment total_books counter
        ; ==========================================
        INC  total_books

        LEA  DX, add_ok_msg
        CALL PRINT_STR
        CALL PAUSE

AB_EXIT:
        POP  DI
        POP  SI
        POP  DX
        POP  CX
        POP  BX
        POP  AX
        RET
ADD_BOOK ENDP

;==========================================================
;  NEW: UPDATE_STOCK
;  Admin enters serial number and new quantity.
;  Directly writes to book_quantities[index].
;==========================================================
UPDATE_STOCK PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI

        CALL CLEAR_SCREEN
        CALL DISPLAY_BOOKS

        ; ask for serial number
        LEA  DX, upd_serial_msg
        CALL PRINT_STR
        CALL READ_CHAR           ; AL = digit character

        ; convert character to 0-based index
        SUB  AL, '1'            ; '1'->0, '2'->1, etc.
        MOV  AH, 0
        CMP  AX, 0
        JB   US_BAD
        MOV  BL, total_books
        MOV  BH, 0
        CMP  AX, BX
        JAE  US_BAD             ; >= total books ? invalid

        MOV  BX, AX             ; BX = 0-based index

        ; ask for new quantity
        LEA  DX, upd_newqty_msg
        CALL PRINT_STR
        LEA  DX, inp_qty_add
        CALL READ_STR

        LEA  SI, inp_qty_add + 2
        CALL ATOI               ; AX = new qty

        MOV  book_quantities[BX], AL   ; update stock

        LEA  DX, stock_ok_msg
        CALL PRINT_STR
        CALL PAUSE
        JMP  US_EXIT

US_BAD:
        LEA  DX, err_choice
        CALL PRINT_STR
        CALL PAUSE

US_EXIT:
        POP  SI
        POP  DX
        POP  CX
        POP  BX
        POP  AX
        RET
UPDATE_STOCK ENDP

;==========================================================
;  NEW: SEARCH_BOOK  (improved)
;  User enters serial number ? shows title, author,
;  price AND stock for that book.
;==========================================================
SEARCH_BOOK PROC
        PUSH AX
        PUSH BX
        PUSH DX
        PUSH SI

        CALL CLEAR_SCREEN
        LEA  DX, search_msg
        CALL PRINT_STR
        CALL READ_CHAR           ; AL = digit character

        ; convert to 0-based index
        SUB  AL, '1'
        MOV  AH, 0
        MOV  BX, AX             ; BX = index

        ; validate: 0 <= BX < total_books
        CMP  BX, 0
        JB   SB_NF
        MOV  AL, total_books
        MOV  AH, 0
        CMP  BX, AX
        JAE  SB_NF

        ; ---- book found ? print details ----
        LEA  DX, search_found
        CALL PRINT_STR

        CALL PRINT_BOOK_DETAILS  ; BX = index, prints all fields
        CALL PAUSE
        JMP  SB_EXIT

SB_NF:
        LEA  DX, search_nf
        CALL PRINT_STR
        CALL PAUSE

SB_EXIT:
        POP  SI
        POP  DX
        POP  BX
        POP  AX
        RET
SEARCH_BOOK ENDP

;==========================================================
;  NEW: PRINT_BOOK_DETAILS
;  Prints title, author, price, stock for book at index BX
;  Input: BX = 0-based book index
;==========================================================
PRINT_BOOK_DETAILS PROC
        PUSH AX
        PUSH CX
        PUSH DX
        PUSH SI

        ; ---- title ----
        LEA  DX, str_title_lbl   ; "  Title  : "
        CALL PRINT_STR
        MOV  AX, BX
        MOV  CX, 30
        MUL  CX
        MOV  SI, AX
        LEA  DX, book_titles
        ADD  DX, SI
        CALL PRINT_STR_CR
        LEA  DX, disp_nl
        CALL PRINT_STR

        ; ---- author ----
        LEA  DX, str_author_lbl  ; "  Author : "
        CALL PRINT_STR
        MOV  AX, BX
        MOV  CX, 20
        MUL  CX
        MOV  SI, AX
        LEA  DX, book_authors
        ADD  DX, SI
        CALL PRINT_STR_CR
        LEA  DX, disp_nl
        CALL PRINT_STR

        ; ---- price ----
        LEA  DX, str_price_lbl   ; "  Price  : RS "
        CALL PRINT_STR
        MOV  AX, BX
        SHL  AX, 1
        MOV  SI, AX
        MOV  AX, book_prices[SI]
        CALL PRINT_NUMBER
        LEA  DX, disp_nl
        CALL PRINT_STR

        ; ---- stock ----
        LEA  DX, str_stock_lbl   ; "  Stock  : "
        CALL PRINT_STR
        MOV  AL, book_quantities[BX]
        MOV  AH, 0
        CALL PRINT_NUMBER
        LEA  DX, disp_nl
        CALL PRINT_STR

        POP  SI
        POP  DX
        POP  CX
        POP  AX
        RET
PRINT_BOOK_DETAILS ENDP

;==========================================================
;  BUY_BOOK  (modified with stock check and deduction)
;==========================================================
BUY_BOOK PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI

        CALL CLEAR_SCREEN
        CALL DISPLAY_BOOKS       ; show inventory first

        ; ---- get serial number ----
        LEA  DX, buy_msg
        CALL PRINT_STR
        CALL READ_CHAR           ; AL = serial character
        SUB  AL, '1'             ; convert to 0-based index
        MOV  AH, 0
        MOV  BX, AX             ; BX = book index

        ; ---- validate serial ----
        CMP  BX, 0
        JB   BB_BAD
        MOV  AL, total_books
        MOV  AH, 0
        CMP  BX, AX
        JAE  BB_BAD

        ; ---- check out-of-stock ----
        MOV  AL, book_quantities[BX]
        CMP  AL, 0
        JE   BB_OOS             ; stock = 0 ? out of stock

        ; ---- get quantity from user ----
        LEA  DX, qty_msg
        CALL PRINT_STR
        CALL READ_CHAR           ; AL = quantity character
        CMP  AL, '1'
        JB   BB_BAD
        CMP  AL, '9'
        JA   BB_BAD

        ; save quantity char in DH for later printing
        MOV  DH, AL
        SUB  AL, '0'            ; convert to numeric
        MOV  CL, AL             ; CL = requested quantity
        MOV  CH, 0

        ; ---- check if enough stock ----
        MOV  AL, book_quantities[BX]
        MOV  AH, 0
        CMP  CX, AX             ; requested > available?
        JA   BB_LOW_STOCK

        ; ---- compute price * qty ----
        ; price offset = BX*2
        MOV  SI, BX
        SHL  SI, 1
        MOV  AX, book_prices[SI]   ; AX = unit price
        MUL  CX                    ; DX:AX = price * qty
        MOV  total, AX

        ; ---- deduct from stock ----
        MOV  AL, book_quantities[BX]
        SUB  AL, CL                ; new stock = old - qty
        MOV  book_quantities[BX], AL

        ; ---- print bill ----
        LEA  DX, bill_hdr
        CALL PRINT_STR

        ; book title
        LEA  DX, bill_book        ; "  Book  : "
        CALL PRINT_STR
        MOV  AX, BX
        MOV  CX, 30
        MUL  CX
        MOV  SI, AX
        LEA  DX, book_titles
        ADD  DX, SI
        CALL PRINT_STR_CR
        LEA  DX, disp_nl
        CALL PRINT_STR

        ; quantity
        LEA  DX, bill_qty         ; "  Qty   : "
        CALL PRINT_STR
        MOV  DL, DH               ; DH had the qty character
        MOV  AH, 02h
        INT  21h
        LEA  DX, disp_nl
        CALL PRINT_STR

        ; unit price
        LEA  DX, bill_unit        ; "  Price : "
        CALL PRINT_STR
        MOV  AX, BX
        SHL  AX, 1
        MOV  SI, AX
        MOV  AX, book_prices[SI]
        CALL PRINT_NUMBER
        LEA  DX, disp_nl
        CALL PRINT_STR

        ; total
        LEA  DX, bill_total       ; "  TOTAL : "
        CALL PRINT_STR
        MOV  AX, total
        CALL PRINT_NUMBER
        LEA  DX, disp_nl
        CALL PRINT_STR

        LEA  DX, bill_end
        CALL PRINT_STR
        LEA  DX, thank_msg
        CALL PRINT_STR
        CALL PAUSE
        JMP  BB_EXIT

BB_OOS:
        ; stock is exactly 0
        LEA  DX, out_of_stock_msg
        CALL PRINT_STR
        CALL PAUSE
        JMP  BB_EXIT

BB_LOW_STOCK:
        ; requested qty > available qty
        ; print: "Sorry! Only X books available."
        LEA  DX, low_stock_msg    ; "!! Sorry! Only "
        CALL PRINT_STR
        MOV  AL, book_quantities[BX]
        MOV  AH, 0
        CALL PRINT_NUMBER
        LEA  DX, low_stock_msg2   ; " books available. !!"
        CALL PRINT_STR
        CALL PAUSE
        JMP  BB_EXIT

BB_BAD:
        LEA  DX, err_choice
        CALL PRINT_STR
        CALL PAUSE

BB_EXIT:
        POP  SI
        POP  DX
        POP  CX
        POP  BX
        POP  AX
        RET
BUY_BOOK ENDP

;==========================================================
;  NEW: ATOI
;  Converts ASCII digit string at DS:SI to unsigned word AX.
;  Stops at 0Dh (Enter) or '$' or non-digit.
;  Input : SI = pointer to first character of digit string
;  Output: AX = numeric value
;  Clobbers: AX, BX, CX, DX, SI (save them in callers)
;==========================================================
ATOI PROC
        PUSH BX
        PUSH CX
        PUSH DX

        MOV  AX, 0               ; accumulator = 0
        MOV  BX, 10              ; multiplier

ATOI_LOOP:
        MOV  CL, [SI]            ; load next character
        MOV  CH, 0

        CMP  CL, 0Dh             ; carriage return ? stop
        JE   ATOI_DONE
        CMP  CL, '$'             ; $ terminator ? stop
        JE   ATOI_DONE
        CMP  CL, '0'             ; below '0' ? not a digit
        JB   ATOI_DONE
        CMP  CL, '9'             ; above '9' ? not a digit
        JA   ATOI_DONE

        SUB  CL, '0'             ; convert ASCII digit to number

        MUL  BX                  ; AX = AX * 10
        ADD  AX, CX              ; AX = AX + new digit

        INC  SI                  ; advance pointer
        JMP  ATOI_LOOP

ATOI_DONE:
        POP  DX
        POP  CX
        POP  BX
        RET
ATOI ENDP

;==========================================================
;       UTILITY PROCEDURES  (all unchanged from original)
;==========================================================

PRINT_STR PROC
        MOV AH, 09h
        INT 21h
        RET
PRINT_STR ENDP

READ_CHAR PROC
        MOV AH, 01h
        INT 21h
        RET
READ_CHAR ENDP

READ_STR PROC
        MOV AH, 0Ah
        INT 21h
        RET
READ_STR ENDP

NEW_LINE PROC
        MOV AH, 02h
        MOV DL, 0Dh
        INT 21h
        MOV DL, 0Ah
        INT 21h
        RET
NEW_LINE ENDP

PAUSE PROC
        LEA  DX, press_any
        MOV  AH, 09h
        INT  21h
        MOV  AH, 01h
        INT  21h
        CALL NEW_LINE
        RET
PAUSE ENDP

CLEAR_SCREEN PROC
        MOV AX, 0600h
        MOV BH, 07h
        MOV CX, 0000h
        MOV DX, 184Fh
        INT 10h
        MOV AH, 02h
        MOV BH, 00h
        MOV DX, 0000h
        INT 10h
        RET
CLEAR_SCREEN ENDP

STR_COMPARE PROC
SC_LOOP:
        MOV AL, [SI]
        MOV BL, [DI]
        CMP AL, 0Dh
        JE  SC_END_S
        CMP BL, '$'
        JE  SC_END_D
        CMP AL, BL
        JNE SC_DIFF
        INC SI
        INC DI
        JMP SC_LOOP
SC_END_S:
        CMP BL, '$'
        JE  SC_EQUAL
        JMP SC_DIFF
SC_END_D:
        CMP AL, 0Dh
        JE  SC_EQUAL
SC_DIFF:
        OR  AL, 1
        RET
SC_EQUAL:
        XOR AL, AL
        RET
STR_COMPARE ENDP

PRINT_NUMBER PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV CX, 0
        MOV BX, 10
PN_DIV:
        MOV DX, 0
        DIV BX
        PUSH DX
        INC CX
        CMP AX, 0
        JNE PN_DIV
PN_OUT:
        POP DX
        ADD DL, '0'
        MOV AH, 02h
        INT 21h
        LOOP PN_OUT

        POP DX
        POP CX
        POP BX
        POP AX
        RET
PRINT_NUMBER ENDP

END MAIN
