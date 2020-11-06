MOD 	; Input R0, R1; Output R0 = R0 % R1
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GCD			; Input R0, R1; Output R0
	PUSH {LR, R2}
GCD_LOOP
	CMP R0, R1          ; Compare a, b
	BEQ _GCD            ; a==b -> Done
	BGT GCD_SUB         ; a>b -> a-=b
	MOV R2, R0          ; swap(a,b)
	MOV R0, R1
	MOV R1, R2
GCD_SUB                 ; a-=b
	SUB R0, R1
	B GCD_LOOP
_GCD
	POP {PC, R2}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCM         ; Input R0, R1; Ouput R0
    PUSH {LR, R2}
    MOV R2, R0      ; Save a
    BL GCD          ; R0 = GCD(a, b)
    MUL R1, R2      ; R1 = a*b
    SDIV R1, R0     ; R1 = R1 / R0
    MOV R0, R1
    POP {LR, R2}