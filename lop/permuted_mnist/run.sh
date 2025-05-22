#!/bin/bash

# Number of CPUs on GCP VM
NUM_CPUS=$(nproc)

declare -a arr=("networkwise_high_repl_rate_abs_gradient")

for i in "${arr[@]}"
do
  FILES=(temp_cfg/$i/*)
  TOTAL_FILES=${#FILES[@]}

  mkdir -p logs/$i

  for ((j=0; j<TOTAL_FILES; j++)); do
      FILE="${FILES[$((j))]}"
      LOG_FILE=./logs/$i/log_$((j)).out

      (
        nohup taskset -c $((j % NUM_CPUS)) \
        python3 online_expr.py -c "$FILE" >> "$LOG_FILE" 2>&1 
        
        echo "EXIT_CODE=$?" >>"$LOG_FILE"
      ) &
  done
done 

wait
