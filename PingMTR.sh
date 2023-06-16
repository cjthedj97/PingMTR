#!/bin/bash

# Default values
mode="icmp"
ip_address=""
log_folder="."  # Path to the log folder


# Function to display script usage
display_usage() {
    echo "Usage: $0 [-m mode] [-ip ip_address]"
    echo "Options:"
    echo "  -m mode            Monitoring mode [Defualt is ICMP] Options: (icmp, tcp, udp)"
    echo "  -ip ip_address     IP address for monitoring"
}

valid_ip_address() {
    local ip="$1"
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ || $ip =~ ^[a-fA-F0-9:]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Parse command-line arguments
while getopts ":m:i:h" opt; do
    case "${opt}" in
        m)
            mode="${OPTARG}"
            ;;
        i)
            ip_address="${OPTARG}"
            ;;
        h)
            display_usage
            exit 0
            ;;
        \?)
            echo "Invalid option: -${OPTARG}" >&2
            display_usage
            exit 1
            ;;
    esac
done

# Check if IP address is provided   
if [ -z "${ip_address}" ]; then
    read -rp "Enter the IP address for monitoring: " ip_address

    # Validate the IP address
    while ! valid_ip_address "${ip_address}"; do
        read -rp "Invalid IP address. Please enter a valid IP address: " ip_address
    done
fi


# Function to perform MTR and log the results
perform_mtr() {
    case "${mode}" in
        icmp)
            mtr -Cbz "${ip_address}" >> "$log_folder/mtr_log_icmp.csv"
            ;;
        tcp)
            mtr -Cbz -T "${ip_address}" >> "$log_folder/mtr_log_tcp.csv"
            ;;
        udp)
            mtr -Cbz -U "${ip_address}" >> "$log_folder/mtr_log_udp.csv"
            ;;
        *)
            echo "Invalid monitoring mode. Supported modes: icmp, tcp, udp"
            display_usage
            exit 1
            ;;
    esac
}

# Infinite loop for continuous monitoring
while true; do
    if ping -c 1 "${ip_address}" >/dev/null 2>&1; then
        echo -e "Ping was successful Waiting "
        for i in `seq 60 -1 1` ; do echo -ne "\r Ping was successful: Waiting $i " ; sleep 1 ; done
    else
        # Ping failed, perform MTR and log the results
        perform_mtr 
    fi
done
