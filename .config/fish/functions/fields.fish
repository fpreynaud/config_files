function fields
	if test (count $argv) -eq 0
		return 1
	end

	# Split input into an array of lines
	set lines
	while read -L b
		set lines $lines $b
	end

	# Get the fields for each line
	for line in $lines
		fields_of_line $line $argv
	end
end

function fields_of_line
	set line $argv[1]
	set field_specs $argv[2..]

	parse_field_spec $line $field_specs[1] | read start end
	set s (get_field_range $line $start $end)

	for spec in $field_specs[2..]
		parse_field_spec $line $spec | read start end
		set s $s (get_field_range $line $start $end)
	end

	echo $s
end

function parse_field_spec
	set line $argv[1]
	set spec $argv[2]
	if string match -q -- '*-*' $spec
		string split -- '-' $spec | read -L start end
	else
		set start $spec
		set end $start
	end

	test -z $start; and set start 1
	test -z $end; and set end (echo $line | awk '{print NF}')

	echo -n $start $end
end

function get_field_range
	set line $argv[1]
	set start $argv[2]
	set end $argv[3]

	set s (echo $line | awk '{print $'$start'}')
	set start (math "$start + 1")
	for field in (seq $start $end)
		set s $s (echo $line | awk '{print $'$field'}')
	end

	echo -n $s
end
