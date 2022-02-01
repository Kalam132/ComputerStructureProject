MAIN start 0							; segment declaration
STM R14, R12, 12(R13)					; storing the register values of the parent segment in its RegSaveArea variable
BALR R12, R0							; storing PC value in R12
using *, R12							; declaration of R12 as the base register
ST R13,SAVEAREA_4
LA R13,SAVEAREA

	
	LA		R10,arr
	LA 		R5,0
LOOP_1_X:
	LA		R6,0
	LA		R11,0
LOOP_2_X:
	LR		R1,R5
    	L 		R15,=V(GET)
    	BALR 		R14,R15
	LR		R7,R2
	LR		R8,R3
	LR		R9,R4
	LR		R1,R6
	L 		R15,=V(GET)
    	BALR 		R14,R15
	CR		R2,R7
	BL		LESS_X
	BH		HIGH_X
	LA		R11,1(R11)
	B		CONTINUE_X
LESS_X:
	C		R4,=F'0'
	BNE		CONTINUE_X
	LA		R11,1(R11)
	B		CONTINUE_X
HIGH_X:
	C		R4,=F'1'
	BNE		CONTINUE_X
	LA		R11,1(R11)
	B		CONTINUE_X
CONTINUE_X:
	LA		R6,1(R6)
	C		R6,N_INPUT
	BL		LOOP_2_X
	C		R11,X_BEST
	BL		LOOSE_X
	ST		R11,X_BEST
	ST		R7,X_ANS
LOOSE_X:
	LA		R5,1(R5)
	C		R5,N_INPUT
	BL		LOOP_1_X



	
	


L  R13,SAVEAREA_4
LM R14,R12,12(R13)
BR R14

N_INPUT 		DC F'2'
Y_BEST		DC F'-100'
Y_ANS		DS F
X_BEST		DC F'-100'
X_ANS		DS F
XY_BEST		DC F'-100'
XY_X_ANS		DS F
XY_Y_ANS		DS F
arr		DC F'0',F'0',F'1',F'6',F'6',F'0'

SAVEAREA  	DS F
SAVEAREA_4	DS 17F

end


GET	START		0
	STM     		R14,R12,12(R13)
	BALR    		R12,R0
	USING   		*,R12
	ST 		R13,SAVEAREA_4(R8)
	LA 		R13,SAVEAREA(R8)


	LA		R7,3
	MR		R6,R1
	SLL		R7,2
	L		R2,0(R7,R10)
	L		R3,4(R7,R10)
	L		R4,8(R7,R10)



	
OUT:

L  	R13,SAVEAREA_4(R8)
LM	R14,R1,12(R13)
LM	R5,R12,40(R13)
BR R14

ONE     		DC F'1'
TWO		DC F'2'
CELLS		DC	100 F'0'
SAVEAREA		DS	F
SAVEAREA_4	DS	719F

end






























