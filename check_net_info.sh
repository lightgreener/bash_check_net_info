#!/bin/env bash

#
#
#
#

function cpu() {
	util=$(vmstat |awk 'if(NR==3)print $13+$14')
	iowait=$(vmstat | awk '{if(NR==3)print $16}')
	echo "cpu : ${util}%; wait : ${iowait}%"
}

function memory() {
	total=$( free -m |awk '{if(NR==2)printf "%.1f", $2/1024}')  # "" followed by comma
	used=$(free -m |awk 'if (NR==2) printf "%.1f", ($2-$NF)/1024')
	available=$(free -m |awk 'if (NR==2) printf "%.1f", $NF/1024')
	echo "total : ${total}G, Used : ${used}G, Available :${available}G"
}                                                

# function ommit
disk() {
	fs=$( df -h | awk '/^\/dev/{print $1}')
	for p in $fs; do
		mounted=$(df -h | awk -v p=$p '$1==p {print $NF}')
		size=$(df -h | awk -v p=$p '$1==p {print $2}')
		used=$(df -h | awk -v p=$p '$1==p {print $3}')
		used_percent=$(df -h | awk -v p=$p '$1==p {print $5}')
		echo "Mounted at $mounted, Size :${size}, Used: ${used} is ${used_percent}"
	done
}

tcp_status() {
	#nt=$( netstat -antp |awk '{a[6]++}END{for (i in a)print i, a[i]}')   diff output	
	nt=$( netstat -antp |awk '{a[6]++}END{for (i in a)print i ":" a[i]""  }') 
	echo $nt
}


cpu
memory
disk
tcp_status

