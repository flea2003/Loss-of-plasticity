#!/bin/sh
#SBATCH --job-name="big_exp"
#SBATCH --array=0-0
#SBATCH --qos=short
#SBATCH --partition=general
#SBATCH --time=4:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1G
#SBATCH --mail-type=END

source ~/.bashrc
conda activate lop

declare -a arr=("l2_activations")

START_INDX=$((8))
END_INDX=$((9))

for i in "${arr[@]}"
do
  FILES=(activation_temp_cfg/$i/*)
  TOTAL_FILES=${#FILES[@]}

  for ((j=START_INDX; j<END_INDX && j<TOTAL_FILES; j++)); do
      FILE="${FILES[$((j))]}"

      # LOG_FILE=./logs/log_$((j)).out
      (
        srun --exclusive --ntasks=1 --cpus-per-task=1  \
        python3 online_expr.py -c "$FILE" >> /dev/null 2>&1 
      ) &
  done
done 

wait
