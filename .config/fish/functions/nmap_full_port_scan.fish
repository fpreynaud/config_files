function nmap_full_port_scan
	echo -e "\x1b[1mPerforming full port scan.\x1b[m"
	argparse 'd/output_dir=' 'p/processes=' -- $argv
	set pool
	set pool_size 2
	set output_dir .
	if set -q _flag_output_dir
		set output_dir $_flag_output_dir
	end
	set -q _flag_processes; and set pool_size $_flag_processes

	for host_file in $argv
		echo -e "\x1b[1mScanning hosts in $host_file.\x1b[m"
		set hosts (command grep Up $host_file | fields 2 | tee -a /tmp/excludefile)

		nmap -Pn \
             -n \
		     -p- \
             --max-rtt-timeout 100ms \
             --max-retries 0 \
             --host-timeout 20m \
             -oN $output_dir/(dated_name tcp_full.nmap) \
             -oG $output_dir/(dated_name tcp_full.gnmap) \
             --open \
             $hosts | command grep -v 'retransmission cap' &

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
