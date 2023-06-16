#!/usr/bin/env bats

# Test command-line argument parsing
@test "Parsing command-line arguments" {
  run ./PingMTR.sh -m icmp -i 192.168.0.1
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
  # Add more assertions to check the values of mode and ip_address variables
}

# Test IP address validation
@test "Validating IP address" {
  run ./PingMTR.sh -m icmp -i invalid_ip
  [ "$status" -eq 0 ]
  [ "$output" = *"Invalid IP address. Please enter a valid IP address:"* ]

  run ./PingMTR.sh -m icmp -i 192.168.0.1
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
  # Add more assertions to check different valid and invalid IP addresses
}

# Test monitoring loop with successful ping
@test "Monitoring loop with successful ping" {
  run ./PingMTR.sh -m icmp -i 192.168.1.1

  # Assert that the script waits for 60 seconds
  [ "$status" -eq 0 ]
  for i in {60..1}; do
    run grep "Waiting $i" <<< "$output"
    [ "$status" -eq 0 ]
  done
  run grep "Ping was successful: Waiting" <<< "$output"
  [ "$status" -eq 0 ]
}

# Mocking function to simulate a failing ping
ping() {
  return 1
}

# Test monitoring loop with failing ping
@test "Monitoring loop with failing ping" {
  run ./PingMTR.sh -m icmp -i 192.168.1.1

  # Assert that the script executed the MTR command
  [ "$status" -eq 0 ]
  [ -f "mtr_log_icmp.csv" ]
  # Add assertions to check if logs are updated and MTR is performed

  # Assert that the script waits for 60 seconds
  [ "$status" -eq 0 ]
  for i in {60..1}; do
    run grep "Waiting $i" <<< "$output"
    [ "$status" -eq 0 ]
  done
  run grep "Ping was successful: Waiting" <<< "$output"
  [ "$status" -eq 1 ]
}

# Cleanup function to remove temporary files
teardown() {
  rm -f "mtr_log_icmp.csv"
}

# Run the tests
@test "Run all tests" {
  run bats pingmtr_test.bats
  [ "$status" -eq 0 ]
}
