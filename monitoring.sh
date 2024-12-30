#!/bin/bash

MEM_TOTAL=$(free -m | awk 'NR==2{print $2}')
MEM_USED=$(free -m | awk 'NR==2{print $3}')
MEM_PERCENT=$(echo "scale=2; $MEM_USED/$MEM_TOTAL*100" | bc)

DISK_TOTAL=$(df -h | grep '/$' | awk '{print $2}')
DISK_USED=$(df -h | grep '/$' | awk '{print $3}')
DISK_PERCENT=$(df -h | grep '/$' | awk '{print $5}')

CPU_LOAD=$(top -bn1 | grep "%Cpu" | awk '{printf("%.1f%%"), $1 + $3}')

lvmt=$(lsblk | grep "lvm" | wc -l)
LVM_USE=$(if [ "$lvmt" -eq 0 ]; then echo no; else echo yes; fi)

IP_ADDR=$(hostname -I | awk '{print $1}')
MAC_ADDR=$(ip link show | awk '/ether/ {print $2}')

SUDO_CMDS=$(grep -c 'COMMAND' /var/log/sudo/sudo.log)

wall "	#Architecture: $(uname -a)
	#CPU physical: $(nproc --all)
	#vCPU: $(nproc)
	#Memory Usage: $MEM_USED/$MEM_TOTAL MB ($MEM_PERCENT%)
	#Disk Usage: $DISK_USED/$DISK_TOTAL ($DISK_PERCENT)
	#CPU load: $CPU_LOAD%
	#Last boot: $(who -b | awk '{print $3, $4}')
	#LVM use: $LVM_USE
	#Connections TCP: $(netstat -ant | grep ESTABLISHED | wc -l)
	#User log: $(who | wc -l)
	#Network: IP $IP_ADDR ($MAC_ADDR)
	#Sudo: $SUDO_CMDS cmd"
