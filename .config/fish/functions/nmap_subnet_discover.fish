function nmap_subnet_discover --description='Perform a quick host discovery on a network range to get a list of subnets with live hosts'
	echo -e "\x1b[1mPerforming subnet discovery.\x1b[m"
	set probe_ports 21,22,23,25,53,80,88,389,443,445,636,1433,3128,3306,3389,5432,8000,8080,8081,8100,8443,8888,9100,9999,10000
	set host_list 1,11,21,33,110,230,254
	set pool
	set pool_size 2
	set output (dated_name subnet_discovery.gnmap)

	argparse 'h/help' 'p/probe_ports=' 'o/output=' 'l/host_list=' 'n/processes=' -- $argv


	if set -q _flag_help
		echo "nmap_subnet_discover [-p/--probe_ports=PORTS_LIST] [-o/--output=OUTPUT_FILE] [-l/--host_list=HOST_LIST] NETWORK" 
		return 0
	end

	set -q _flag_probe_ports; and set probe_ports $_flag_probe_ports
	set -q _flag_output; and set output $_flag_output
	set -q _flag_host_list; and set host_list $_flag_host_list
	set -q _flag_processes; and set pool_sise $_flag_processes

	echo "[+] Initializing..."
	set nets (nmap -n -sL $argv[1] | command grep -i 'nmap scan report' | awk '{print $5}' | cut -f 1-3 -d. | sort -u)
	echo -e "[+] Starting subnet discovery on $argv[1]."

	for net in $nets
		nmap -sn \
			 -PS$probe_ports  \
			 -n \
			 --min-hostgroup 64 \
			 --max-rtt-timeout 100ms \
			 --max-retries 0 \
			 --host-timeout 30s \
			 -oG $output \
			 --append \
			 --open \
			 $net.{$host_list} $argv[2..] | command grep -v 'retransmission cap hit' &

		 set pool $pool $last_pid
		 # Remove finished jobs from pool
		 for i in (seq (count $pool) -1 1)
		 	if test -z (jobs -p | grep '^'$pool[$i]'$')
				set -e pool[$i]
			end
		 end

		 # Wait for one of the scans to finish if the job pool is full
		 if test (count $pool) -ge $pool_size
		 	wait -n $pool
		 end
	end
end
