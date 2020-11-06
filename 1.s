; DE 1
; 1. Tinh tong cac so cua duong cheo phu
; 2. Dem so nguyen to tren duong cheo chinh
	AREA RESET, DATA, READONLY
		DCD 0x20001000
		DCD Start

	AREA _DATA, DATA, READONLY
ARR DCD 1,2,3,4
	DCD 2,2,3,4
	DCD 3,2,3,4
	DCD 4,2,3,4
	
	AREA _CODE, CODE, READONLY

;;;;;;;;;;;;;;;;;;
; 1
;;;;;;;;;;;;;;;;;;
SUM			; Input R0: Matrix_addr, R1: N; Output R0: Sum
	PUSH {LR, R2-R6}
	MOV R2, R0	; Matrix Address
	MOV R3, R1  ; Iterator
	MOV R4, #0	; SUM
	ADD R2, #12	; Dia chi cua Phan tu dau tien cua duong cheo phu
SUM_NEXT
	CMP R3, #0				; Check if n==0
	BLE _SUM				; n<=0 => Jump _SUM
	SUB R3, #1				; n-=1
	LDR R6, [R2], #12		; R6 = Matrix[i]; Matrix+=1;
	ADD R4, R6
	B SUM_NEXT
_SUM
	MOV R0, R4				; Output
	POP {PC, R2-R6}				
	


;;;;;;;;;;;;;;;;;;
; 2
;;;;;;;;;;;;;;;;;;
MOD 	; Input R0, R1; Output R0 = R0%R1
	PUSH {LR, R2}
	SDIV R2, R0, R1			; R2 = (int) R0/R1
	MLS R0, R2, R1, R0		; R0 = R0 - (R2*R1)
	POP {PC, R2}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IS_PRIME 				; Input R0, Output R0
	PUSH {LR, R1-R3}
	MOV R1, 0           ; i
	MOV R2, 0           ; Count Divisor
	MOV R3, R0
IS_PRIME_NEXT
	CMP R1, R3          ; Compare i, a
	BGE IS_PRIME_CHECK  ; i>=a -> Check Count_Divisor
	ADD R1, #1          ; i+=1
	
	MOV R0, R3
	BL MOD              ; R0 = a % i
	CMP R0, #0
	BNE IS_PRIME_NEXT
	ADD R2, #1          ; Count Divisor += 1
	B IS_PRIME_NEXT
IS_PRIME_CHECK
	CMP R2, #2          ; Compare Count_Divisor
	BEQ IS_PRIME_TRUE   ; =2 -> Is Prime
IS_PRIME_FALSE
	MOV R0, #0
	B _IS_PRIME
IS_PRIME_TRUE
	MOV R0, #1
_IS_PRIME
	POP {PC, R1-R3}


COUNT			; Input R0: Matrix_addr, R1: N; Output R0: Count
	PUSH {LR, R2-R6}
	MOV R2, R0	; Matrix Address
	MOV R3, R1  ; Iterator
	MOV R4, #0	; Count
COUNT_NEXT
	CMP R3, #0				; Check if n==0
	BLE _COUNT				; n<=0 => Jump _COUNT
	SUB R3, #1				; n-=1
	LDR R6, [R2], #20		; R6 = Matrix[i]; Matrix+=1;
	MOV R0, R6
	BL IS_PRIME
	CMP R0, #1				; KT
	BNE COUNT_NEXT			; R0 != 1 => Jump COUNT_NEXT
	ADD R4, #1				; count += 1
	B COUNT_NEXT
_COUNT
	MOV R0, R4
	POP {PC, R2-R6}
	
;;;;;;;;;;;;;;;;;;
; Main
;;;;;;;;;;;;;;;;;;
Start
	LDR R0, =ARR
	MOV R1, #4		;BIEN CHAY
	BL SUM			; Output R0: Sum
	MOV R11, R0		; Ket qua tong duong cheo phu
	
	LDR R0, =ARR
	MOV R1, #4		;BIEN CHAY
	BL COUNT		;Output R0: Count
	MOV R12, R0		; Ket qua dem SNT duong cheo chinh
_END	B	_END

END