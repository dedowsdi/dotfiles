#!/bin/bash -x

# print memory or cpu snapshot when used_memory_percent or used_cpu_percent exceed some point

CPU_THRESHOLD=70
MEM_THRESHOLD=80
REPORT_FILE=~/pfsnap_$(date +%Y%m%d)

while getopts "m:c:" Option ; do
    case $Option in
        m     ) MEM_THRESHOLD=$OPTARG  ;;
        c     ) CPU_THRESHOLD=$OPTARG  ;;
        *     ) echo "Unimplemented option:$Option" ; exit 1 ;;
    esac
done

time=$(date +%Y.%m.%d_%H:%M:%S)
# get used memory percent
read total_memory used_memory<<<$(free -m | sed -n '2p' | tr -s ' ' |cut -d ' '  -f 2,3)
used_mem_percent=$(echo "scale=1; 100*$total_memory/$used_memory"|bc)

# get used cpu persent
idle_cpu=$(top -bn1 | grep Cpu | grep -oP '[0-9.]+(?=\s*id)')
used_cpu_percent=$(echo "100-$idle_cpu"|bc)

if [[ $CPU_THRESHOLD < $used_cpu_percent ]]; then
    {
        echo 
        echo --------------------------------------
        echo cpu
        echo "$time"
        top -bn1 | sed -n '1,17p' 
    } >> "$REPORT_FILE"
fi

if [[ $MEM_THRESHOLD < $used_mem_percent ]]; then
    {
        echo 
        echo --------------------------------------
        echo mem
        echo "$time"
        top -bn1 | sed -n '1,17p' 
    } >> "$REPORT_FILE"
fi
