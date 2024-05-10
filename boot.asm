[BITS 16]           ; YNSRC
[ORG 0x7C00]        ; Simple Bootloader

MOV AH, 0x00        ; set video mode
MOV AL, 0x03        ; text mode 80x25 16 colors 8 pages
INT 10h             ; call BIOS interrupt

MOV SI, HelloText    ; SI = HelloText's address
CALL PrintText       ; call PrintText function
CALL BreakLine       ; new line

; function to read one character from keyboard

ReadChar:
MOV AH, 0x00        ; set AH register for read mode

INT 0x16            ; call BIOS interrupt

CMP AL, 13          ; if readed key is (Return / Enter) 
JE  CrLf            ; call new line function

JMP Continue        ; continue to print

CrLf:               ; alias for BreakLine (new line)
CALL BreakLine      ; call BreakLine function

Continue:

CALL Print          ; call Print function
    
JMP ReadChar        ; jump to ReadChar function0

JMP $               ; forever (halt BIOS here if read - write loop breaked) 

; function to print character

Print:
MOV AH, 0x0E
MOV BH, 0x00

INT 0x10            ; call bios interrupt

RET

BreakLine:          ; print CR+LF (10 and 13 in HEX) for new line

MOV AL, 10
CALL Print
MOV AL, 13
CALL Print

RET

; print a text to screen which defined with 'db' at the bottom

PrintText:
Next:
MOV AL, [SI]        ; put the address of text which assigned to SI into AL register
INC SI              ; increment by 1 the SI memory address (move to next character)
OR AL, AL           ; when reached end of the text (readed 0 character)
JZ Finish           ; jump to Finish
CALL Print          ; call Print function
JMP Next            ; jump to Next label to loop over text until the end of text
Finish:
RET                 ; return to caller function

; Data

HelloText db 'YNSRC (Open Source) Bootloader V1.0', 0

TIMES 510 - ($ - $$) db 0    ; fill space to reach 510 bytes size
DW 0xAA55                    ; put AA and 55 to ensure 512 byte MBR size
