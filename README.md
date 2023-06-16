# PingMTR.sh

The PingMTR.sh script is a bash script that performs continuous monitoring of an IP address using ping and MTR (My TraceRoute) commands. It allows you to monitor the network connectivity and measure the network path characteristics to the specified IP address.

## Usage

To use the script, you can provide command-line arguments or let the script prompt you for the necessary information.

```bash
Usage: ./PingMTR.sh [-m mode] [-ip ip_address]

Options:
  -m mode            Monitoring mode [Default is ICMP] Options: (icmp, tcp, udp)
  -ip ip_address     IP address for monitoring
```

## Monitoring Modes

The script supports three monitoring modes: ICMP, TCP, and UDP. By default, the ICMP mode is used.

* ICMP mode: Sends ICMP (Internet Control Message Protocol) echo requests to the specified IP address to check the reachability and measure round-trip time.
* TCP mode: Performs MTR using TCP (Transmission Control Protocol) packets to measure network path characteristics and latency.
* UDP mode: Performs MTR using UDP (User Datagram Protocol) packets to measure network path characteristics and latency.

## Continuous Monitoring

The script runs in an infinite loop, continuously monitoring the specified IP address. It uses the ping command to check the reachability of the IP address. If the ping is successful, the script waits for a period of time (60 seconds by default) and then pings again. If the ping fails, the script performs MTR and logs the results.

## MTR Logging

The script logs the MTR results to separate CSV files based on the monitoring mode:

    mtr_log_icmp.csv: Logs the MTR results in ICMP mode.
    mtr_log_tcp.csv: Logs the MTR results in TCP mode.
    mtr_log_udp.csv: Logs the MTR results in UDP mode.

The log files are saved in the specified log folder (default is the current directory).
## IP Address Validation

The script validates the provided IP address using a simple regular expression pattern. It checks if the IP address is a valid IPv4 or IPv6 address format. If the IP address is not provided as a command-line argument or if an invalid IP address is entered, the script prompts the user to enter a valid IP address.

That's the description of the PingMTR.sh script. It provides flexible monitoring options, continuous monitoring, MTR logging, and IP address validation to help you monitor network connectivity and measure network path characteristics.