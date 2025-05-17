#!/bin/bash

# Number of CPUs on GCP VM
NUM_CPUS=$(nproc)

declare -a arr=("bp" "cbp" "different_layers", "high_repl_rate")

for i in "${arr[@]}"
do
  FILES=(temp_cfg/$i/*)
  TOTAL_FILES=${#FILES[@]}

  mkdir -p logs/$i

  for ((j=0; j<TOTAL_FILES; j++)); do
      FILE="${FILES[$i]}"
      LOG_FILE=./logs/$i/log_${j}.out

      # Assign 1 CPU per task (not enforced, but helps manage load)
      taskset -c $((j % NUM_CPUS)) \
        python3 online_expr.py -c "$FILE" >> "$LOG_FILE" 2>&1 &
  done
done 

wait
