;==========================================================
;  ONLINE BOOK SHOP MANAGEMENT SYSTEM
;  Platform : EMU8086 
;  Author   : MUHAMMAD UMER & IBRAHIM SAUD 
;==========================================================

.MODEL SMALL
.STACK 100H

;==========================================================
;                    DATA SEGMENT
;==========================================================
.DATA

;----- Welcome Screen -----
welcome_msg     db 0Dh,0Ah,"==================================================",0Dh,0Ah
                db "        ONLINE BOOK SHOP MANAGEMENT SYSTEM       ",0Dh,0Ah
                db "==================================================",0Dh,0Ah
                db "        Welcome to BRO'S UNITED BOOK WORLD           ",0Dh,0Ah
                db "==================================================",0Dh,0Ah,0Dh,0Ah
                db "         Press any key to continue...$"

;----- Main Menu -----
main_menu       db 0Dh,0Ah,"--------------- MAIN MENU ---------------",0Dh,0Ah
                db "  1. User  Login",0Dh,0Ah
                db "  2. Admin Login",0Dh,0Ah
                db "  3. Exit",0Dh,0Ah
                db "-----------------------------------------",0Dh,0Ah
                db "  Enter your choice : $"

;----- User Menu -----
user_menu       db 0Dh,0Ah,"--------------- USER MENU ---------------",0Dh,0Ah
                db "  1. View Book Categories",0Dh,0Ah
                db "  2. Search Book by Serial No.",0Dh,0Ah
                db "  3. Buy Book (Cart & Billing)",0Dh,0Ah
                db "  4. Logout",0Dh,0Ah
                db "-----------------------------------------",0Dh,0Ah
                db "  Enter your choice : $"

;----- Login Prompts -----
prompt_user     db 0Dh,0Ah,"Enter Username (max 9 chars) : $"
prompt_pass     db 0Dh,0Ah,"Enter Password (max 9 chars) : $"

;----- Hard-coded credentials -----
user_pass       db "ibrahim$"        ; user password
admin_pass      db "umer$"           ; admin password

;----- Input buffers (DOS function 0Ah) -----
buf_user        db 10, 0, 10 dup('$')
buf_pass        db 10, 0, 10 dup('$')

;----- Category Menu -----
cat_menu        db 0Dh,0Ah,"------------ BOOK CATEGORIES ------------",0Dh,0Ah
                db "  1. Programming",0Dh,0Ah
                db "  2. Fiction",0Dh,0Ah
                db "  3. Science",0Dh,0Ah
                db "  4. Back",0Dh,0Ah
                db "-----------------------------------------",0Dh,0Ah
                db "  Enter your choice : $"

;----- Book lists (Serial - Title - Price) -----
cat_prog_hdr    db 0Dh,0Ah,"------------- PROGRAMMING BOOKS -------------",0Dh,0Ah,"$"
cat_fic_hdr     db 0Dh,0Ah,"---------------- FICTION BOOKS --------------",0Dh,0Ah,"$"
cat_sci_hdr     db 0Dh,0Ah,"---------------- SCIENCE BOOKS --------------",0Dh,0Ah,"$"

book1           db "  1. Let Us C            by Y. Kanetkar     Price: 250 RS",0Dh,0Ah,"$"
book2           db "  2. C++ Primer          by Lippman         Price: 400 RS",0Dh,0Ah,"$"
book3           db "  3. Harry Potter        by J.K. Rowling    Price: 500 RS",0Dh,0Ah,"$"
book4           db "  4. The Alchemist       by Paulo Coelho    Price: 300 RS",0Dh,0Ah,"$"
book5           db "  5. A Brief History     by S. Hawking      Price: 450 RS",0Dh,0Ah,"$"
book6           db "  6. Cosmos              by Carl Sagan      Price: 350 RS",0Dh,0Ah,"$"

;----- Numeric prices (parallel to books) -----
prices          dw 250, 400, 500, 300, 450, 350

;----- Search prompts -----
search_msg      db 0Dh,0Ah,"Enter book serial no (1-6) : $"
search_found    db 0Dh,0Ah,"Book Found!",0Dh,0Ah,"$"
search_nf       db 0Dh,0Ah,"Book NOT Found!",0Dh,0Ah,"$"

;----- Billing -----
buy_msg         db 0Dh,0Ah,"Enter book serial no to buy (1-6) : $"
qty_msg         db 0Dh,0Ah,"Enter quantity (1-9) : $"
bill_hdr        db 0Dh,0Ah,"================ BILL RECEIPT ===============",0Dh,0Ah,"$"
bill_book       db "Book Serial : $"
bill_qty        db 0Dh,0Ah,"Quantity    : $"
bill_unit       db 0Dh,0Ah,"Unit Price  : $"
bill_total      db 0Dh,0Ah,"Total       : $"
bill_end        db 0Dh,0Ah,"=============================================",0Dh,0Ah,"$"
thank_msg       db 0Dh,0Ah,"Thank you for shopping at Bro'sUnited BookWorld!",0Dh,0Ah,"$"

;----- Error / status -----
err_choice      db 0Dh,0Ah,"!! Invalid Choice. Try again. !!",0Dh,0Ah,"$"
err_login       db 0Dh,0Ah,"!! Wrong Username or Password !!",0Dh,0Ah,"$"
ok_login        db 0Dh,0Ah,">> Login Successful <<",0Dh,0Ah,"$"
bye_msg         db 0Dh,0Ah,"Goodbye! Program terminated.",0Dh,0Ah,"$"
press_any       db 0Dh,0Ah,"Press any key to continue...$"

;----- Admin view -----
admin_hdr       db 0Dh,0Ah,"============ FULL INVENTORY (ADMIN) ===========",0Dh,0Ah,"$"

;----- Temporary -----
total           dw 0
tens_str        db "    $"     ; for number print buffer

.CODE
;==========================================================
;                    MAIN PROGRAM
;==========================================================
MAIN PROC
        MOV AX, @DATA
        MOV DS, AX

        ;--- show welcome screen ---
        CALL CLEAR_SCREEN
        LEA DX, welcome_msg
        CALL PRINT_STR
        CALL READ_CHAR            ; wait for key

MAIN_LOOP:
        CALL CLEAR_SCREEN
        LEA DX, main_menu
        CALL PRINT_STR
        CALL READ_CHAR            ; choice in AL

        CMP AL, '1'
        JE  GO_USER
        CMP AL, '2'
        JE  GO_ADMIN
        CMP AL, '3'
        JE  GO_EXIT

        ;--- invalid choice ---
        LEA DX, err_choice
        CALL PRINT_STR
        CALL PAUSE
        JMP MAIN_LOOP

GO_USER:
        CALL USER_LOGIN
        JMP MAIN_LOOP

GO_ADMIN:
        CALL ADMIN_LOGIN
        JMP MAIN_LOOP

GO_EXIT:
        LEA DX, bye_msg
        CALL PRINT_STR
        MOV AH, 4Ch
        INT 21h
MAIN ENDP

;==========================================================
;                USER LOGIN PROCEDURE
;==========================================================
USER_LOGIN PROC
        CALL CLEAR_SCREEN
        LEA DX, prompt_user
        CALL PRINT_STR
        LEA DX, buf_user
        CALL READ_STR

        LEA DX, prompt_pass
        CALL PRINT_STR
        LEA DX, buf_pass
        CALL READ_STR

        ;--- compare entered password with "user" ---
        LEA SI, buf_pass + 2      ; actual chars start at offset 2
        LEA DI, user_pass
        CALL STR_COMPARE          ; ZF=1 if equal
        JNE  UL_FAIL

        LEA DX, ok_login
        CALL PRINT_STR
        CALL PAUSE
        CALL USER_MENU_PROC
        RET

UL_FAIL:
        LEA DX, err_login
        CALL PRINT_STR
        CALL PAUSE
        RET
USER_LOGIN ENDP

;==========================================================
;                ADMIN LOGIN PROCEDURE
;==========================================================
ADMIN_LOGIN PROC
        CALL CLEAR_SCREEN
        LEA DX, prompt_user
        CALL PRINT_STR
        LEA DX, buf_user
        CALL READ_STR

        LEA DX, prompt_pass
        CALL PRINT_STR
        LEA DX, buf_pass
        CALL READ_STR

        LEA SI, buf_pass + 2
        LEA DI, admin_pass
        CALL STR_COMPARE
        JNE  AL_FAIL

        LEA DX, ok_login
        CALL PRINT_STR
        CALL SHOW_ALL_BOOKS
        CALL PAUSE
        RET

AL_FAIL:
        LEA DX, err_login
        CALL PRINT_STR
        CALL PAUSE
        RET
ADMIN_LOGIN ENDP

;==========================================================
;                USER MENU PROCEDURE
;==========================================================
USER_MENU_PROC PROC
UM_LOOP:
        CALL CLEAR_SCREEN
        LEA DX, user_menu
        CALL PRINT_STR
        CALL READ_CHAR

        CMP AL, '1'
        JE  UM_CAT
        CMP AL, '2'
        JE  UM_SEARCH
        CMP AL, '3'
        JE  UM_BUY
        CMP AL, '4'
        JE  UM_OUT

        LEA DX, err_choice
        CALL PRINT_STR
        CALL PAUSE
        JMP UM_LOOP

UM_CAT:
        CALL CATEGORY_MENU
        JMP UM_LOOP
UM_SEARCH:
        CALL SEARCH_BOOK
        JMP UM_LOOP
UM_BUY:
        CALL BUY_BOOK
        JMP UM_LOOP
UM_OUT:
        RET
USER_MENU_PROC ENDP

;==========================================================
;                CATEGORY MENU
;==========================================================
CATEGORY_MENU PROC
CM_LOOP:
        CALL CLEAR_SCREEN
        LEA DX, cat_menu
        CALL PRINT_STR
        CALL READ_CHAR

        CMP AL, '1'
        JE  CM_PROG
        CMP AL, '2'
        JE  CM_FIC
        CMP AL, '3'
        JE  CM_SCI
        CMP AL, '4'
        JE  CM_BACK

        LEA DX, err_choice
        CALL PRINT_STR
        CALL PAUSE
        JMP CM_LOOP

CM_PROG:
        LEA DX, cat_prog_hdr
        CALL PRINT_STR
        LEA DX, book1
        CALL PRINT_STR
        LEA DX, book2
        CALL PRINT_STR
        CALL PAUSE
        JMP CM_LOOP
CM_FIC:
        LEA DX, cat_fic_hdr
        CALL PRINT_STR
        LEA DX, book3
        CALL PRINT_STR
        LEA DX, book4
        CALL PRINT_STR
        CALL PAUSE
        JMP CM_LOOP
CM_SCI:
        LEA DX, cat_sci_hdr
        CALL PRINT_STR
        LEA DX, book5
        CALL PRINT_STR
        LEA DX, book6
        CALL PRINT_STR
        CALL PAUSE
        JMP CM_LOOP
CM_BACK:
        RET
CATEGORY_MENU ENDP

;==========================================================
;                SHOW ALL BOOKS (Admin)
;==========================================================
SHOW_ALL_BOOKS PROC
        LEA DX, admin_hdr
        CALL PRINT_STR
        LEA DX, book1
        CALL PRINT_STR
        LEA DX, book2
        CALL PRINT_STR
        LEA DX, book3
        CALL PRINT_STR
        LEA DX, book4
        CALL PRINT_STR
        LEA DX, book5
        CALL PRINT_STR
        LEA DX, book6
        CALL PRINT_STR
        RET
SHOW_ALL_BOOKS ENDP

;==========================================================
;                SEARCH BOOK
;==========================================================
SEARCH_BOOK PROC
        CALL CLEAR_SCREEN
        LEA DX, search_msg
        CALL PRINT_STR
        CALL READ_CHAR              ; serial digit in AL

        CMP AL, '1'
        JB  SB_NF
        CMP AL, '6'
        JA  SB_NF

        LEA DX, search_found
        CALL PRINT_STR
        CALL PRINT_BOOK_BY_AL       ; show that book
        JMP SB_END

SB_NF:
        LEA DX, search_nf
        CALL PRINT_STR
SB_END:
        CALL PAUSE
        RET
SEARCH_BOOK ENDP

;==========================================================
;                BUY BOOK + BILLING
;==========================================================
BUY_BOOK PROC
        CALL CLEAR_SCREEN
        LEA DX, buy_msg
        CALL PRINT_STR
        CALL READ_CHAR
        MOV BL, AL                  ; save serial char in BL

        CMP BL, '1'
        JB  BB_BAD
        CMP BL, '6'
        JA  BB_BAD

        LEA DX, qty_msg
        CALL PRINT_STR
        CALL READ_CHAR              ; quantity '1'..'9'
        CMP AL, '1'
        JB  BB_BAD
        CMP AL, '9'
        JA  BB_BAD
        MOV BH, AL                  ; quantity char in BH

        ;--- compute index = BL - '1' ---
        MOV AL, BL
        SUB AL, '1'                 ; AL = 0..5
        MOV AH, 0
        SHL AX, 1                   ; index * 2 (word array)
        MOV SI, AX
        MOV AX, prices[SI]          ; unit price in AX

        ;--- quantity to numeric ---
        MOV CL, BH
        SUB CL, '0'                 ; CL = 1..9
        MOV CH, 0
        ;--- total = AX * CX ---
        MUL CX                      ; DX:AX = price * qty (we ignore DX)
        MOV total, AX

        ;--- print bill ---
        LEA DX, bill_hdr
        CALL PRINT_STR
        LEA DX, bill_book
        CALL PRINT_STR
        MOV DL, BL
        MOV AH, 02h
        INT 21h                     ; print serial digit

        LEA DX, bill_qty
        CALL PRINT_STR
        MOV DL, BH
        MOV AH, 02h
        INT 21h                     ; print qty digit

        LEA DX, bill_unit
        CALL PRINT_STR
        MOV AX, prices[SI]
        CALL PRINT_NUMBER

        LEA DX, bill_total
        CALL PRINT_STR
        MOV AX, total
        CALL PRINT_NUMBER

        LEA DX, bill_end
        CALL PRINT_STR
        LEA DX, thank_msg
        CALL PRINT_STR
        CALL PAUSE
        RET

BB_BAD:
        LEA DX, err_choice
        CALL PRINT_STR
        CALL PAUSE
        RET
BUY_BOOK ENDP

;==========================================================
;                PRINT BOOK BY AL ( '1'..'6' )
;==========================================================
PRINT_BOOK_BY_AL PROC
        CMP AL, '1'
        JNE PB2
        LEA DX, book1
        JMP PB_DONE
PB2:    CMP AL, '2'
        JNE PB3
        LEA DX, book2
        JMP PB_DONE
PB3:    CMP AL, '3'
        JNE PB4
        LEA DX, book3
        JMP PB_DONE
PB4:    CMP AL, '4'
        JNE PB5
        LEA DX, book4
        JMP PB_DONE
PB5:    CMP AL, '5'
        JNE PB6
        LEA DX, book5
        JMP PB_DONE
PB6:    LEA DX, book6
PB_DONE:
        CALL PRINT_STR
        RET
PRINT_BOOK_BY_AL ENDP

;==========================================================
;       UTILITY PROCEDURES
;==========================================================

;----- PRINT_STR : prints '$'-terminated string at DS:DX ----
PRINT_STR PROC
        MOV AH, 09h
        INT 21h
        RET
PRINT_STR ENDP

;----- READ_CHAR : reads 1 char into AL, echoes it ---------
READ_CHAR PROC
        MOV AH, 01h
        INT 21h
        RET
READ_CHAR ENDP

;----- READ_STR : reads buffered string (INT 21h fn 0Ah) ---
;     DS:DX -> buffer ( byte0=maxlen, byte1=actuallen )
READ_STR PROC
        MOV AH, 0Ah
        INT 21h
        RET
READ_STR ENDP

;----- NEW_LINE : prints CR/LF -----------------------------
NEW_LINE PROC
        MOV AH, 02h
        MOV DL, 0Dh
        INT 21h
        MOV DL, 0Ah
        INT 21h
        RET
NEW_LINE ENDP

;----- PAUSE : print "press any key", wait, newline --------
PAUSE PROC
        LEA DX, press_any
        MOV AH, 09h
        INT 21h
        MOV AH, 01h
        INT 21h
        CALL NEW_LINE
        RET
PAUSE ENDP

;----- CLEAR_SCREEN : BIOS scroll-up (works in EMU8086) ----
CLEAR_SCREEN PROC
        MOV AX, 0600h           ; scroll whole window
        MOV BH, 07h             ; attribute = grey on black
        MOV CX, 0000h           ; top-left
        MOV DX, 184Fh           ; bottom-right (24,79)
        INT 10h
        ;--- reset cursor ---
        MOV AH, 02h
        MOV BH, 00h
        MOV DX, 0000h
        INT 10h
        RET
CLEAR_SCREEN ENDP

;----- STR_COMPARE : compares ASCIIZ-ish strings at SI / DI
;     stops at '$' or 0Dh; sets ZF=1 if equal
STR_COMPARE PROC
SC_LOOP:
        MOV AL, [SI]
        MOV BL, [DI]
        ;--- treat CR (0Dh) at SI as end-of-input ---
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
        ;--- input ended; check DI also at terminator ---
        CMP BL, '$'
        JE  SC_EQUAL
        JMP SC_DIFF
SC_END_D:
        ;--- pattern ended but input has more chars ---
        CMP AL, 0Dh
        JE  SC_EQUAL
SC_DIFF:
        OR  AL, 1                ; clear ZF
        RET
SC_EQUAL:
        XOR AL, AL               ; set ZF=1
        RET
STR_COMPARE ENDP

;----- PRINT_NUMBER : prints unsigned word in AX (decimal) -
PRINT_NUMBER PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV CX, 0                ; digit counter
        MOV BX, 10
PN_DIV:
        MOV DX, 0
        DIV BX                   ; DX = AX mod 10 ; AX = AX/10
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
