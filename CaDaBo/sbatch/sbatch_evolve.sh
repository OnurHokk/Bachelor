#!/bin/bash
#SBATCH --job-name="evolve yolov5"
#SBATCH --partition=gpu
#SBATCH --gres=gpu:4
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=evolve.log
#SBATCH --error=evolve.err.log
#SBATCH --chdir=/work/ws-tmp/g022788-bachelor/yolov5/

eval "$(conda shell.bash hook)"
conda activate bachelor

# Multi-GPU
# for i in 0 1 2 3; do
#   # sleep $(expr 5 \* $i) &&  # 30-second delay (optional)
#   echo 'Starting GPU '$i'...' &&
#   nohup python train.py --epochs 10 \
#                         --data CaDaBo-11/data.yaml \
#                         --hyp hyp.fullaugadam.yaml \
#                         --optimizer 'Adam' \
#                         --weights yolov5m.pt \
#                         --img 960 \
#                         --cache \
#                         --device $i \
#                         --evolve 1 > evolve_gpu_$i.log &
# done


# Multi-GPU
for i in 0 1 2 3; do
  sleep $((10 * i)) &&
  echo "Starting GPU $i..." &&
  python train.py --epochs 50 \
                  --data CaDaBo-11/data.yaml \
                  --hyp hyp.fullaugadam.yaml \
                  --optimizer 'Adam' \
                  --weights yolov5m.pt \
                  --img 960 \
                  --cache \
                  --device $i \
                  --evolve 500 > evolve_gpu_$i.log 2>&1 &
done

wait