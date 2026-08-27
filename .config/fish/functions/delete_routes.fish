#!/usr/bin/fish

function delete_routes
	set routes (command ip r)
	set routes_count (count $routes)

	set i 1
	for r in $routes
		echo $i\) $r
		set i (math $i' + 1')
	end

	read -P "Choose route to delete: " REPLY
	set REPLY (string split ' ' $REPLY)

	function is_num
		set is_number 1
		if test $argv[1] -eq $argv[1]
			set is_number 0 # Will not be executed if $argv[1] is not a number
		end 2>/dev/null
		return $is_number
	end

	# Ignore duplicates, non-numbers, and invalid indices in REPLY
	set routes_to_delete 
	for r in $REPLY
		if not contains $r $routes_to_delete; 
		and is_num $r; 
		and test $r -ge 1; and test $r -le $routes_count
			set routes_to_delete $routes_to_delete $r
		end
	end

	# Delete the routes
	for i in $routes_to_delete
		set route (string replace ' linkdown' '' $routes[$i])
		set command "sudo ip route del $route"
		echo $command
		eval $command
	end
end
