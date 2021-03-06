
; j:\c463\fa02\compuSum.hlp
; sompuSum.asm is an External Procedure (Subroutine) to Prog03b.asm

Extrn      Len1:Byte
Extrn      Num1:Byte
Extrn      Len2:Byte
Extrn      Num2:Byte
Extrn      Bin1:Word
Extrn      Bin2:Word
Extrn      AnsMsg:Byte
Extrn      Integer:Byte
Extrn      Float:Byte
Extrn      Integral:Byte
Extrn      Fraction:Byte

Public     compuSum

	  .Model Small
	  .Code

compuSum   PROC  Far

; Input:   Num1 is the integer value        (in ASCII characters)
;          Num2 is the floating-point value (in ASCII characters)

; Input:   Bin1 is the integer value        (in binary)
;          Bin2 is the floating-point value (in binary)

           xor  cx,cx         ; copy Num1 to Integer (in ASCII)
           mov  cl,Len1
           lea  si,Num1
           lea  di,Integer
           rep  movsb

           xor  cx,cx         ; copy Num2 to Float (in ASCII)
           mov  cl,Len2
           lea  si,Num2
           lea  di,Float
           rep  movsb

           xor  cx,0          ; Computes the number of digits in the
           lea  si,Num2       ; Integral part of the Floating-point   
nextDgt:   mov  al,[si]       ; constant, and saves it into CX
           cmp  al,'.'
           je   frcPart       ; Assume: 48.25 = 34 38 . 32 35 0D
           inc  cx            ; Then, CX = 2
           inc  si
           jmp  nextDgt

frcPart:   inc  si            ; si points to First Digit of Floaing-point 
           lea  di,Fraction   ; di points to the position following '.'
           inc  di            

           mov  al,Len2       ; 34 38 . 32 35 ->  al = 5
           sub  al,cl         ; al = al - cl = 5 - 2 = 3
           mov  cl,al         ; cl = al = 3
           dec  cx            ; cx = cx - 1 = 2 = # of digits in float-point
           rep  movsb         ; 32 35 copied to Fraction field

           mov  ax,Bin1       ; ax = 10 (Integer constant = 16 = 10h)
           mov  bx,Bin2       ; bx = 30 (Integral = 48 = 30h)
           add  ax,bx         ; ax = 40 = 64 in decimal

           lea  si,Integral   ; si points to Integral field
           cmp  ax,99
           ja   QMore99
           cmp  ax,9  
           ja   QMore9  

           or   al,30h        ; if ax = 0, 1, 2, . . , 9
           mov  [si+2],al     ; convert it to ASCII character, and copy it
           jmp  printAns      ; to Integral field, then print it

QMore9:    mov  bl,10         ; if ax = 10, 11, 12, . . , 99
           div  bl            ; convert it to ASCII characters, and copy  
           or   al,30h        ; them to Integral field, then print them  
           mov  [si+1],al     ; e.g., if ax = 48, then ax/bl = 48/10
           or   ah,30h        ; -> 08 in AH and 04 in AL
           mov  [si+2],ah     ; -> 34 = [si+1]
           jmp  printAns      ; -> 38 = [si+2]

	   
			;********************************************************************
			;********************************************************************
			;********************************************************************
QMore99:   mov  bl,100        ; if ax = 100, 101, 102, . . , 999
           div  bl            ; convert it to ASCII characters, and copy
           or   al,30h        ; them to Integral field, then print them
                        
           mov  [si+1],al     ; e.g., ax = 567, then ax/bl = 567/100 
           or   ah,30h        ; -> ah = 67, al = 5
           mov  [si+2],ah     ; -> al OR 30h = 35h = [si]
           jmp  printAns      ; -> mov al,ah -> al = 67, and ah = 0 
                              ; -> ax/bl = 67/10 -> ah = 7, al = 6 
                              ; -> al OR 30h -> 36h = [si+1] 
                              ; -> ah OR 30h -> 37h = [si+2]
                         

			;********************************************************************
			;********************************************************************
			;********************************************************************


printAns:  lea  dx, AnsMsg
           mov  ah, 09h
           int  21h

	   ret
compuSum   ENDP
	   END          
