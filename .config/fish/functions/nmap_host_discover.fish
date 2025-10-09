function nmap_host_discover --description='Discover live hosts in /24 subnets'
	echo -e "\x1b[1mPerforming host discovery.\x1b[m"
	set probe_ports 21,22,23,25,53,80,88,389,443,445,636,1433,3128,3306,3389,5432,8000,8080,8081,8100,8443,8888,9100,9999,10000
	set pool_size 3
	set output (dated_name host_discovery.gnmap)
	argparse 'h/help' 'f/nmap_file=' 'o/output=' 'p/processes' -- $argv
	if set -q _flag_help
		echo "nmap_host_discover [-f/--nmap_file] [-o/--output] [-p/--processes] SUBNET..." NMAP_ARGS
		return 0
	end

	set nmap_args $argv

	if not set -q _flag_nmap_file
		echo "Missing mandatory option -f/--nmap_file" >&2
		return 1
	end

	set -q _flag_output; and set output $_flag_output
	set -q _flag_processes; and set pool_size $_flag_processes

	# Convert IPs in nmap_file into /24 subnets
	set subnets (command grep Up $_flag_nmap_file | fields 2 | cut -f 1-3 -d . | xargs -I% echo %.0/24 | sort -u)


	# For each subnet do host discovery. Store the results in one file per subnet
	for subnet in $subnets
		echo -e "\x1b[1mPerforming host discovery in subnet $subnet.\x1b[m"
		set prefix (string replace '/' '_' $subnet)
		nmap -sn \
			 -PS$probe_ports  \
			 -n \
			 --min-hostgroup 256 \
			 --max-rtt-timeout 100ms \
			 --max-retries 0 \
			 --host-timeout 30s \
			 -oG {$prefix}_$output \
			 --open \
			 $subnet $nmap_args | command grep -v 'retransmission cap hit' &

		set pool $pool $last_pid

		# Remove finished jobs from pool
		for i in (seq (count $pool) -1 1)
			if test -z (jobs -p | grep '^'$pool[$i]'$')
				set -e pool[$i]
			end
		end

		# Wait for one of the scans to finish if the job pull is full
		if test (count $pool) -ge $pool_size
			wait -n $pool
		end
	end
end
