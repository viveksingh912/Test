
iterations=1000

# Compile your C++ code with the specified flags
g++ -o your_program your_program.cpp  -std=c++11 -fsanitize=address -fsanitize=undefined -fno-sanitize-recover

# Check if compilation was successful
if [ $? -ne 0 ]; then
    echo "Compilation failed."
    exit 1
fi

total_runtime=0

for ((i = 1; i <= $iterations; i++)); do
    echo "Running iteration $i/$iterations..."
    # Measure runtime using the 'time' command and redirect output to a file
    (time ./your_program) 2>> benchmark_results.txt
done
total_real_time=0
while read line; do
    if [[ $line =~ real[[:space:]]*([0-9]+)m([0-9.]+)s ]]; then
        minutes="${BASH_REMATCH[1]}"
        seconds="${BASH_REMATCH[2]}"
        real_time_milliseconds=$(echo "$minutes * 60000 + $seconds * 1000" | bc)
        total_real_time=$(echo "$total_real_time + $real_time_milliseconds" | bc)
    fi
done < benchmark_results.txt
# Calculate the average runtime
echo $total_real_time
echo "Average runtime over $iterations iterations: $total_real_time miliseconds"

# Clean up: remove the program and results file
rm your_program benchmark_results.txt
