#!/bin/bash

# Number of CPUs on GCP VM
NUM_CPUS=$(nproc)

declare -a arr=("cbp")

for i in "${arr[@]}"
do
  FILES=(temp_cfg/$i/*)
  TOTAL_FILES=${#FILES[@]}

  mkdir -p logs/$i

  for ((j=0; j<16; j++)); do
      FILE="${FILES[$j]}"
      LOG_FILE=./logs/$i/log_${j}.out

      # Assign 1 CPU per task (not enforced, but helps manage load)
      taskset -c $((j % NUM_CPUS)) \
        python3 online_expr.py -c "$FILE" >> "$LOG_FILE" 2>&1 &
  done
done 

wait
