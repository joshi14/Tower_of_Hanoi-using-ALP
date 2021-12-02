include 'emu8086.inc'

.model small       ;to use data segment and stack segment

.data              ;data segment

text db "Move from peg "
d1 db ?                   ;source peg
text2 db " to peg "
d2 db ?                   ;destination peg
newline db 0AH, 0DH, '$'  ;for new line and carriage return

.code                     ;code segment
main proc
   
    mov ax, @data     ;set up the data segment to accumalator
   
    print 'Enter the number of discs : '
    printn
    CALL SCAN_NUM      ;to get number of discs from the keyboard
   
    mov ds, ax

    mov ax, 1
    push ax            ;peg 1 is pushed
    mov ax, 2
    push ax            ;peg 2 is pushed
    mov ax, 3
    push ax            ;peg 3 is pushed
    mov ax, cx
    push ax            ;number of disks is pushed
    call solve
   
    mov ax, 4C00H      ;to make the program exit immediately
    int 21h


main endp

solve proc
   push bp             ;to access parameters passed by the stack
   mov bp, sp          ;set bp for referencing stack
   cmp word ptr ss:[bp+4], 0   ;check for empty peg
   je down                     ;jump to down
   
   push word ptr ss:[bp+0AH]    ;offset of 10 from base pointer ie., 1st peg
   push word ptr ss:[bp+6]      ;2nd peg
   push word ptr ss:[bp+8]      ;3rd peg
   mov ax, word ptr ss:[bp+4]   ;disc
   dec ax                    ;to move to the next disc
   push ax                   ;push the popped disc
   call solve                ;recursive call

   push word ptr ss:[bp+0AH]
   push word ptr ss:[bp+08]
   call pr                   ;call pr

   push word ptr ss:[bp+6]   ;repeat
   push word ptr ss:[bp+8]
   push word ptr ss:[bp+0AH]
   mov ax, word ptr ss:[bp+4]
   dec ax
   push ax
   call solve

   pop bp
   ret 8
down:
   pop bp             ;pop the disc
   ret 8

solve endp

pr proc
   push bp
   mov bp, sp                    
   mov d1, '0'                   ;source peg
   mov al, byte ptr ss:[bp+6]    ;offset of 6 from base pointer is moved to al
   add d1, al                    ;the value in al is added with value in d1
   mov d2, '0'                   ;destination peg
   mov al, byte ptr ss:[bp+4]    ;offset of 4 from base pointer is moved to al
   add d2, al                    ;the value in al is added with value in d2
   lea dx, text    ;the address specified by text is placed in the dx register and the corresponding peg number is printed
   mov ah, 09      ;to write the string to standard output
   int 21h         ;interrupt
   pop bp
   ret 4

pr endp
DEFINE_PRINT_STRING
DEFINE_SCAN_NUM
end