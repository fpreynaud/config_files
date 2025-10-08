function dated_name
	argparse 'f/format' -- $argv
	set format "%y%m%d%H%M%S"
	set -q _flag_format; and set format $_flag_format

	string split -r -m 1 . $argv[1] | read -L name extension
	echo {$name}_(date +{$format}).{$extension}
end
