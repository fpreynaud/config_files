set $SHOW_ASM = 1
set $SHOW_REGISTERS = 1
set $SHOW_STACK = 1
set $INSTRUCTIONS_BEFORE = 3
set $STACK_DISPLAY_SIZE = 4
set $old_eax = 0
set $old_ebx = 0
set $old_ecx = 0
set $old_edx = 0
set $old_esp = 0
set $old_ebp = 0
set $previous_eip = 0
set disassembly-flavor intel

define green-line
	echo \033[32m
	echo \n--------------------------------------------------------\n
	echo \033[0m
end
document green-line
	Print a green line
end

define reg
	if $SHOW_REGISTERS == 1
		green-line
		echo Registers
		green-line
		echo \033[31m
		printf "eax: " 
		echo \033[0m
		if $eax != $old_eax
			echo \033[33m
			set $old_eax = $eax
		end
		printf "%08x ",$eax
		echo \033[0m
		echo \033[31m
		printf "ebx: "
		echo \033[0m
		if $ebx != $old_ebx
			echo \033[33m
			set $old_ebx = $ebx
		end
		printf "%08x ",$ebx
		echo \033[31m
		printf "ecx: "
		echo \033[0m
		if $ecx != $old_ecx
			echo \033[33m
			set $old_ecx = $ecx
		end
		printf "%08x ",$ecx
		echo \033[31m
		printf "edx: "
		echo \033[0m
		if $edx != $old_edx
			echo \033[33m
			set $old_edx = $edx
		end
		printf "%08x\n",$edx
		echo \033[31m
		printf "esp: "
		echo \033[0m
		if $esp != $old_esp
			echo \033[33m
			set $old_esp = $esp
		end
		printf "%08x ",$esp
		echo \033[31m
		printf "ebp: "
		echo \033[0m
		if $ebp != $old_ebp
			echo \033[33m
			set $old_ebp = $ebp
		end
		printf "%08x ",$ebp
		echo \033[31m
		printf "eip: "
		echo \033[0m
		if $eip != (int)$previous_eip
			echo \033[33m
			set $previous_eip = $eip
		end
		printf "%08x",$eip
		echo \033[0m
	end
	echo \n
end
document reg
	Show values of registers
end

define stack
	if $SHOW_STACK == 1
		echo\n
		green-line
		echo Stack
		green-line
		set $n = 4
		if $argc == 1
			set $n = $arg0
			set $STACK_DISPLAY_SIZE = $arg0
		end
		set $i = 0
		while $i < $n
			if $i == 0
				if $ebp == $esp
					echo \033[33m
					printf "=> "
					echo \033[0m
				else
					printf "=> "
				end
			else
				if $ebp == $esp + 4*$i
					echo \033[33m
					printf "=> "
					echo \033[0m
				else
					printf "   "
				end
			end
			x/xw $esp + 4*$i
			set $i = $i + 1
		end
	end
end
document stack
	Display the stack
end

define asm_context
	if $SHOW_ASM == 1
		echo \n
		green-line
		echo Assembly
		green-line
		set $i = $INSTRUCTIONS_BEFORE
		while $i > 1
			eval "set $x = $old_eip%d",$i
			eval "set $y = $old_eip%d",$i - 1
			if $x != $y
				x/1i $x
			end
			set $i = $i - 1
		end
		if $old_eip1 != $eip
			x/1i $old_eip1
		end
		eval "x/-%di $eip",$INSTRUCTIONS_BEFORE
		x/10i $eip
	end
end
document asm_context
	Show code around current program counter
end

define showstack
	if $argc == 0
		if $SHOW_STACK == 1
			set $SHOW_STACK = 0
		else
			set $SHOW_STACK = 1
		end
	else
		set $SHOW_STACK = $arg0
	end
end
document showstack
	Toggle display of the stack
end

define showasm
	if $argc == 0
		if $SHOW_ASM == 1
			set $SHOW_ASM = 0
		else
			set $SHOW_ASM = 1
		end
	else
		set $SHOW_ASM = $arg0
	end

end
document showasm
	Toggle showing code around current program counter
end

define showregs
	if $argc == 0
		if $SHOW_REGISTERS == 1
			set $SHOW_REGISTERS = 0
		else
			set $SHOW_REGISTERS = 1
		end
	else
		set $SHOW_REGISTERS = $arg0
	end
end
document showregs
	Toggle showing registers
end

define context-off
	showasm 0
	showregs 0
end
document context-off
	Switch display of context off
end

define context-on
	showasm 1
	showregs 1
end
document context-on
	Switch display of context on
end

define init-eips
	if $argc == 0
		set $i = $INSTRUCTIONS_BEFORE
		set $INSTRUCTIONS_BEFORE_SAVE = $INSTRUCTIONS_BEFORE
	else
		set $i = $arg0
		set $INSTRUCTIONS_BEFORE_SAVE = $INSTRUCTIONS_BEFORE
		set $INSTRUCTIONS_BEFORE = $arg0
	end

	set $j = $i
	while $j > 0
		eval "set $x = $old_eip%d",$j
		if $_isvoid ($x) == 1
			eval "set $old_eip%d = $eip",$j
		end
		set $j = $j - 1
	end

	if $i < $INSTRUCTIONS_BEFORE_SAVE
		set $j = $INSTRUCTIONS_BEFORE_SAVE
		while $j > $i
			eval "set $old_eip%d = $old_eip%d",$j,$i
			set $j = $j - 1
		end
	end
end
document init-eips
	Initialize $old_eip<n> variables
end

define hook-stop
	reg
	init-eips
	asm_context
	stack $STACK_DISPLAY_SIZE

	set $i = $INSTRUCTIONS_BEFORE
	while $i > 1
		eval "set $old_eip%d = $old_eip%d",$i,$i-1
		set $i = $i - 1
	end
	set $old_eip1 = $eip
end
document hook-stop
	What to do on program breaks
end

define _run
	break *main + 0
	if $argc == 0
		run
	else
	if $argc == 1
		run $arg0 
	else
	if $argc == 2
		run $arg0 $arg1
	else
	if $argc == 3
		run $arg0 $arg1 $arg2
	else
	if $argc == 4
		run $arg0 $arg1 $arg2 $arg3
	else
	if $argc == 5
		run $arg0 $arg1 $arg2 $arg3 $arg4
	else
	if $argc == 6
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5
	else
	if $argc == 7
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6
	else
	if $argc == 8
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7
	else
	if $argc == 9
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8
	else
	if $argc == 10
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9
	else
	if $argc == 11
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10
	else
	if $argc == 12
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11
	else
	if $argc == 13
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12
	else
	if $argc == 14
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13
	else
	if $argc == 15
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14
	else
	if $argc == 16
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15
	else
	if $argc == 17
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16
	else
	if $argc == 18
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17
	else
	if $argc == 19
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18
	else
	if $argc == 20
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19
	else
	if $argc == 21
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20
	else
	if $argc == 22
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21
	else
	if $argc == 23
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22
	else
	if $argc == 24
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23
	else
	if $argc == 25
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24
	else
	if $argc == 26
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25
	else
	if $argc == 27
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26
	else
	if $argc == 28
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27
	else
	if $argc == 29
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28
	else
	if $argc == 30
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29
	else
	if $argc == 31
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30
	else
	if $argc == 32
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31
	else
	if $argc == 33
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32
	else
	if $argc == 34
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33
	else
	if $argc == 35
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34
	else
	if $argc == 36
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35
	else
	if $argc == 37
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36
	else
	if $argc == 38
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37
	else
	if $argc == 39
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38
	else
	if $argc == 40
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38 $arg39
	else
	if $argc == 41
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38 $arg39 $arg40
	else
	if $argc == 42
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38 $arg39 $arg40 $arg41
	else
	if $argc == 43
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38 $arg39 $arg40 $arg41 $arg42
	else
	if $argc == 44
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38 $arg39 $arg40 $arg41 $arg42 $arg43
	else
	if $argc == 45
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38 $arg39 $arg40 $arg41 $arg42 $arg43 $arg44
	else
	if $argc == 46
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38 $arg39 $arg40 $arg41 $arg42 $arg43 $arg44 $arg45
	else
	if $argc == 47
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38 $arg39 $arg40 $arg41 $arg42 $arg43 $arg44 $arg45 $arg46
	else
	if $argc == 48
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38 $arg39 $arg40 $arg41 $arg42 $arg43 $arg44 $arg45 $arg46 $arg47
	else
	if $argc == 49
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38 $arg39 $arg40 $arg41 $arg42 $arg43 $arg44 $arg45 $arg46 $arg47 $arg48
	else
	if $argc == 50
		run $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11 $arg12 $arg13 $arg14 $arg15 $arg16 $arg17 $arg18 $arg19 $arg20 $arg21 $arg22 $arg23 $arg24 $arg25 $arg26 $arg27 $arg28 $arg29 $arg30 $arg31 $arg32 $arg33 $arg34 $arg35 $arg36 $arg37 $arg38 $arg39 $arg40 $arg41 $arg42 $arg43 $arg44 $arg45 $arg46 $arg47 $arg48 $arg49
	end
	set $old_eax = $eax
	set $old_ebx = $ebx
	set $old_ecx = $ecx
	set $old_edx = $edx
	set $old_esp = $esp
	set $old_ebp = $ebp
end
document _run
	Create breakpoint at main and run program
end
