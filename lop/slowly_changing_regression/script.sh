#!/bin/sh
#SBATCH --job-name="slowly-2"
#SBATCH --partition=compute
#SBATCH --time=20:00:00
#SBATCH --array=0-9
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem-per-cpu=3G
#SBATCH --output=./logs/log_%A_%a.out
#SBATCH --error=./logs/log_%A_%a.err

module load 2023r1
module load miniconda3/4.12.0
conda activate lop

START_INDX=$((SLURM_ARRAY_TASK_ID * 40))
END_INDX=$((START_INDX + 39))

FILES=(temp_cfg/*)
TOTAL_FILES=${#FILES[@]}

for ((i=START_INDX; i<=END_INDX && i<TOTAL_FILES; i++)); do
    FILE="${FILES[$i]}"

    TASK_NUMBER=$((i - START_INDX + 1))
    echo "=== STARTING TASK NUMBER $TASK_NUMBER ... ==="
    
    LOG_FILE=./logs/log_${SLURM_ARRAY_TASK_ID}_${TASK_NUMBER}_.out
    srun --exclusive --ntasks=1 --cpus-per-task=1 python3 expr.py -c "$FILE" >> "$LOG_FILE" 2>&1 &
done

wait