define reg
	echo \033[32m
	echo \n----------------------------------------------\n
	echo \033[31m
	printf "eax: " 
	echo \033[0m
	printf "%x ",$eax
	echo \033[0m
	echo \033[31m
	printf "ebx: "
	echo \033[0m
	printf "%x ",$ebx
	echo \033[31m
	printf "ecx: "
	echo \033[0m
	printf "%x ",$ecx
	echo \033[31m
	printf "edx: "
	echo \033[0m
	printf "%x\n",$edx
	echo \033[31m
	printf "esp: "
	echo \033[0m
	printf "%x ",$esp
	echo \033[31m
	printf "ebp: "
	echo \033[0m
	printf "%x ",$ebp
	echo \033[31m
	printf "eip: "
	echo \033[0m
	printf "%x\n",$eip
	echo \033[32m
	echo ----------------------------------------------\n
	echo \033[0m
end

define hook-stop
	reg
end
