#!/bin/bash

# Output file
outputFile="system_stats.txt"

# Array to store stats
cpu_usages=()
mem_usages=()

# Function to get CPU usage
get_cpu_usage() {
    top -bn1 | awk '/^%Cpu/ {print 100 - $8}'
}

# Function to get memory usage
get_memory_usage() {
    free -m | awk 'NR==2 {print $3*100/$2}'
}

# Print header
printf "Timestamp\tCPU Usage\tMemory Usage\n" > "$outputFile"

# Main loop to monitor system stats for  minutes (in seconds)
end=$((SECONDS+3900))
while [ $SECONDS -lt $end ]; do
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    cpu_usage=$(get_cpu_usage)
    mem_usage=$(get_memory_usage)

    # Append stats to output file
    printf "%s\t%.2f%%\t%.2f%%\n" "$timestamp" "$cpu_usage" "$mem_usage" >> "$outputFile"

    # Store stats in arrays
    cpu_usages+=("$cpu_usage")
    mem_usages+=("$mem_usage")

    sleep 10  # Sleep for 10 seconds
done

# Calculate and print max, min, and average CPU usage
# Adding a line for testing 
max_cpu=$(printf "%s\n" "${cpu_usages[@]}" | sort -nr | head -n 1)
min_cpu=$(printf "%s\n" "${cpu_usages[@]}" | sort -n | head -n 1)
avg_cpu=$(echo "${cpu_usages[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum/NR}')

# Calculate and print max, min, and average memory usage
max_mem=$(printf "%s\n" "${mem_usages[@]}" | sort -nr | head -n 1)
min_mem=$(printf "%s\n" "${mem_usages[@]}" | sort -n | head -n 1)
avg_mem=$(echo "${mem_usages[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum/NR}')

# Print max, min, and average CPU usage to output file
printf "\nMaximum CPU Usage: %.2f%%\n" "$max_cpu" >> "$outputFile"
printf "Minimum CPU Usage: %.2f%%\n" "$min_cpu" >> "$outputFile"
printf "Average CPU Usage: %.2f%%\n" "$avg_cpu" >> "$outputFile"

# Print max, min, and average memory usage to output file
printf "\nMaximum Memory Usage: %.2f%%\n" "$max_mem" >> "$outputFile"
printf "Minimum Memory Usage: %.2f%%\n" "$min_mem" >> "$outputFile"
printf "Average Memory Usage: %.2f%%\n" "$avg_mem" >> "$outputFile"

