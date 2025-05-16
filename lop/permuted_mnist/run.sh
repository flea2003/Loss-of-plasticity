#!/bin/bash

# Number of CPUs on GCP VM
NUM_CPUS=$(nproc)

FILES=(temp_cfg/networkwise/*)
TOTAL_FILES=${#FILES[@]}

mkdir -p logs/networkwise

for ((i=0; i<TOTAL_FILES; i++)); do
    FILE="${FILES[$i]}"
    LOG_FILE=./logs/networkwise/log_${i}.out

    # Assign 1 CPU per task (not enforced, but helps manage load)
    taskset -c $((i % NUM_CPUS)) \
      python3 online_expr.py -c "$FILE" >> "$LOG_FILE" 2>&1 &
done

wait
