#!/bin/bash

# 控制台颜色
BLACK="\033[1;30m"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
CYAN="\033[1;36m"
RESET="$(tput sgr0)"

printf "${PURPLE}"
cat <<EOF

===========================================================================
@description: 获取系统相关信息 
@system: 适用于所有 linux 发行版本。
===========================================================================

EOF
printf "${RESET}"
system_info(){
    echo "-------------------------------System Info----------------------------------"
    echo -e "Hostname:\t\t"`hostname`
    echo -e "uptime:\t\t\t"`uptime | awk '{print $3,$4}' | sed 's/,//'`
    echo -e "Manufacturer:\t\t"`cat /sys/class/dmi/id/chassis_vendor`
    echo -e "Product Name:\t\t"`cat /sys/class/dmi/id/product_name`
    echo -e "Version:\t\t"`cat /sys/class/dmi/id/product_version`
    echo -e "Serial Number:\t\t"`cat /sys/class/dmi/id/product_serial`
    echo -e "Machine Type:\t\t"`vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi`
    echo -e "Operating System:\t"`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`
    echo -e "Kernel:\t\t\t"`uname -r`
    echo -e "Architecture:\t\t"`arch`
    echo -e "Processor Name:\t\t"`awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//'`
    echo -e "Active User:\t\t"`w | cut -d ' ' -f1 | grep -v USER | xargs -n1`
    echo -e "System Main IP:\t\t"`hostname -I`
    echo ""
}
mem_info() {
    echo "-------------------------------Memory Info----------------------------------"
	MemTotal=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
	MemFree=$(awk '/MemFree/ {print $2}' /proc/meminfo)
	Buffers=$(awk '/^Buffers:/ {print $2}' /proc/meminfo)
	Cached=$(awk '/^Cached:/ {print $2}' /proc/meminfo)
	FreeMem=$(($MemFree / 1024 + $Buffers / 1024 + $Cached / 1024))
	UsedMem=$(($MemTotal / 1024 - $FreeMem))
	echo -e "Total memory is ${GREEN} $(($MemTotal / 1024)) MB ${RESET}"
	echo -e "Free  memory is ${GREEN} ${FreeMem} MB ${RESET}"
	echo -e "Used  memory is ${GREEN} ${UsedMem} MB ${RESET}"
	echo ""
}
disk_info() {
    echo "--------------------------------Disk Info------------------------------------"
	DISK=$(df -ThP | column -t)
	echo -e "${GREEN}$DISK ${RESET}"
    echo ""
    echo "-------------------------------------------------------------------------------"
}
system_info
mem_info 
disk_info 