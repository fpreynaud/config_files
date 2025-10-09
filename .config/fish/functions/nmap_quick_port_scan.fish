function nmap_quick_port_scan
	echo -e "\x1b[1mPerforming quick port scan.\x1b[m"
	argparse 'd/output_dir=' 'p/processes=' -- $argv
	set pool
	set pool_size 5
	set output_dir .

	set -q _flag_output_dir; and set output_dir $_flag_output_dir
	set -q _flag_processes; and set pool_size $_flag_processes

	for host_file in $argv
		echo -e "\x1b[1mProcessing $host_file.\x1b[m"
		set hosts (command grep Up $host_file | fields 2)
		nmap -Pn \
             -n \
             -F \
             --max-rtt-timeout 100ms \
             --max-retries 0 \
             -v \
             -oG $output_dir/(dated_name tcp_fast.gnmap) \
             -oN $output_dir/(dated_name tcp_fast.nmap) \
             --open $hosts | command grep -v 'retransmission cap' &

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
