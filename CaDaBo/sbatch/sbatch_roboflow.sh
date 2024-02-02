#!/bin/bash
#SBATCH --job-name="roboflow download"
#SBATCH --time=0:10:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem 100MB
#SBATCH --partition=short
#SBATCH --output=roboflow.log
#SBATCH --error=roboflow.log
#SBATCH --chdir=/work/ws-tmp/g022788-bachelor/yolov5/


eval "$(conda shell.bash hook)"
conda activate bachelor

echo "Downloading roboflow database into: "
pwd

python "/work/ws-tmp/g022788-bachelor/bachelor/sbatch/roboflow_download.py"