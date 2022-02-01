.text



main:
	la $a0, dim_input
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s4, $v0		# $s4 = n
	move $a0, $s4
	mult $a0, $a0
	mflo $a0
	sll $a0, $a0, 1		# $a0 = 2 * 10 * 10
	sll $a0, $a0, 2
	li $v0, 9
	syscall
	sw $v0, mat

	la $a0, mat_input
	li $v0, 4
	syscall
	move $t0, $0		# $t0 = i
	sll $s0, $s4, 2
	lw $s1, mat
	take_input_out:
		slt $t2, $t0, $s0
		beqz $t2, end_take_input_out
		move $t1, $0		# $t1 = j
		take_input_in:
			slt $t2, $t1, $s0
			beqz $t2, end_take_input_in

			mult $s4, $t0
			mflo $t3
			sll $t3, $t3, 1
			add $t3, $t3, $t1
			add $t3, $t3, $s1

			li $v0, 6
			syscall
			s.s $f0, 0($t3)

			addi $t1, $t1, 4
			j take_input_in
		end_take_input_in:
		addi $t0, $t0, 4
		j take_input_out
	end_take_input_out:

	move $a0, $s4
	jal solve



	move $t0, $0		# $t0 = i
	sll $s0, $s4, 2
	lw $s1, mat
	print_out:
		slt $t2, $t0, $s0
		beqz $t2, end_print_out
		move $t1, $0		# $t1 = j
		print_in:
			slt $t2, $t1, $s0
			beqz $t2, end_print_in

			mult $s4, $t0
			mflo $t3
			sll $t3, $t3, 1
			add $t3, $t3, $t1
			add $t3, $t3, $s1
			add $t3, $t3, $s0

			li $v0, 2
			l.s $f12, 0($t3)
			syscall


			li $v0, 4
			la $a0, space
			syscall

			addi $t1, $t1, 4
			j print_in
		end_print_in:
		li $v0, 4
		la $a0, newline
		syscall
		addi $t0, $t0, 4
		j print_out
	end_print_out:




	li $v0, 10
	syscall



solve:

	addi $sp, $sp, -16
	sw $ra, 0($sp)			# storing $ra for returning to the caller
	sw $a0, 4($sp)			# storing values which store return values of F and are overwritten in the function
	sw $s0, 8($sp)
	sw $s4, 12($sp)

	# $a0 = n
	sll $s0, $a0, 2
	sll $s1, $s0, 1
	lw $s2, mat

	move $t0, $0
	loop_1_out:
		slt $t2, $t0, $s0
		beqz $t2, end_loop_1_out
		move $t1, $0
		loop_1_in:
			slt $t2, $t1, $s0
			beqz $t2, end_loop_1_in
			seq $t2, $t0, $t1
			mtc1 $t2, $f0
			cvt.s.w $f0, $f0		# $f0 = (i == j)
			mult $t0, $a0
			mflo $t3
			sll $t3, $t3, 1
			add $t3, $t3, $t1
			add $t3, $t3, $s0
			add $t3, $t3, $s2
			s.s $f0, 0($t3)
			addi $t1, $t1, 4
			j loop_1_in
		end_loop_1_in:
		addi $t0, $t0, 4
		j loop_1_out
	end_loop_1_out:


	move $t0, $0			# $t0 = i
	lui $t5, 0x3586
	ori $t5, $t5, 0x37BD
	mtc1 $t5, $f5			# $f5 = 0.000001
	loop_2_out:
		slt $t2, $t0, $s0
		beqz $t2, end_loop_2_out
		mult $t0, $a0
		mflo $t3
		sll $t3, $t3, 1
		add $t3, $t3, $t0
		add $t3, $t3, $s2
		l.s $f0, 0($t3)		# $f0 = a[i][i]
		c.lt.s $f0, $f5
		bc1t return
		move $t1, $0		# $t1 = j

		loop_2_in:
			slt $t2, $t1, $s0
			beqz $t2, end_loop_2_in
			beq $t0, $t1, skip
			mult $t1,$a0
			mflo $t3
			sll $t3, $t3, 1
			add $t3, $t3, $t0
			add $t3, $t3, $s2
			l.s $f1, 0($t3)
			div.s $f2, $f1, $f0		# $f2 = ratio

			move $t4, $0			# # $t4 = k
			loop_2_deep:
				slt $t2, $t4, $s1
				beqz $t2, end_loop_2_deep
				mult $t0,$a0
				mflo $t3
				sll $t3, $t3, 1
				add $t3, $t3, $t4
				add $t3, $t3, $s2
				l.s $f3, 0($t3)		# $f3 = a[i][k]
				mul.s $f4, $f2, $f3	# $f4 = ratio * a[i][k]
				mult $t1,$a0
				mflo $t3
				sll $t3, $t3, 1
				add $t3, $t3, $t4
				add $t3, $t3, $s2
				l.s $f3, 0($t3)		# $f3 = a[j][k]
				sub.s $f3, $f3, $f4
				s.s $f3, 0($t3)
				add $t4, $t4, 4
				j loop_2_deep
			end_loop_2_deep:

			skip:
			addi $t1, $t1, 4
			j loop_2_in
		end_loop_2_in:

		addi $t0, $t0, 4
		j loop_2_out

	end_loop_2_out:



	move $t0, $0
	loop_3_out:
		slt $t2, $t0, $s0
		beqz $t2, end_loop_3_out

		mult $t0, $a0
		mflo $t3
		sll $t3, $t3, 1
		add $t3, $t3, $t0
		add $t3, $t3, $s2
		l.s $f0, 0($t3)		# $f0 = a[i][i]

		move $t1, $s0
		loop_3_in:
			slt $t2, $t1, $s1
			beqz $t2, end_loop_3_in

			mult $t0, $a0
			mflo $t3
			sll $t3, $t3, 1
			add $t3, $t3, $t1
			add $t3, $t3, $s2
			l.s $f1, 0($t3)		# $f1 = a[i][j]
			div.s $f1, $f1, $f0
			s.s $f1, 0($t3)

			addi $t1, $t1, 4
			j loop_3_in
		end_loop_3_in:

		addi $t0, $t0, 4
		j loop_3_out
	end_loop_3_out:






	return:
		lw $ra, 0($sp)
		lw $a0, 4($sp)
		lw $s0, 8($sp)
		lw $s4, 12($sp)
		addi $sp, $sp, 16
		jr $ra




.data

	mat: .word 0

	newline: .asciiz "\n"
	space: .asciiz " "
	dim_input: .asciiz "Please enter dimension of the matrix: "
	mat_input: .asciiz "Please enter the matrix entries:\n"
	inv_mat: .asciiz "The matrix inverse is:\n"


