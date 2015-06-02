#!/bin/bash

probeCmd='nc -w1 $host 22 > /dev/null 2>&1'
hosts=($(awk 'BEGIN{ORS=" "} /^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?/ { for(i=2; i<=NF; i++) print $i }' /etc/hosts))

usage() {
    echo "Usage: $0"
    echo ""
    echo "   Probes all hostnames in /etc/hosts on port 22."
    echo "   Reports whether or not the host can be reached."

}

if [ -n "$1" ]; then
    case "$1" in
        -h) 
            usage; exit 0;;
        --help)
            usage; exit 0;;
        *)
            usage; exit 0;;
        esac
fi

for host in "${hosts[@]}"; do
    echo -n "Testing $host... "
    eval $probeCmd
    if [ $? -eq 0 ]; then
        echo "passed"
    else
        echo "failed"
    fi
done
