#!/bin/bash
#SBATCH --job-name="train yolov5"
#SBATCH --time=4:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem 50G
#SBATCH --partition=gpu
#SBATCH --gpus=2
#SBATCH --array=1-2
#SBATCH --output=train_%A_%a.log
#SBATCH --error=train_error_%A_%a.log
#SBATCH --chdir=/work/ws-tmp/g022788-bachelor/yolov5/


eval "$(conda shell.bash hook)"
conda activate bachelor

export COMET_API_KEY="262SXJpiFMwChydRzzwhGNGTT"
export COMET_PROJECT_NAME="CaDaBoV3-citroen-960"
export COMET_LOG_PER_CLASS_METRICS=true

case $SLURM_ARRAY_TASK_ID in
    1)
        comet python train.py \
                --device 0 \
                --hyp hyp.adam0.0001-new.yaml \
                --optimizer 'Adam' \
                --name 'adam0.0001-new' \
                --img 960 \
                --batch 16 \
                --epochs 1800 \
                --data CaDaBo-11/data.yaml \
                --weights yolov5m.pt \
                --bbox_interval 1 \
                --save-period 180
        ;;
    2)
        comet python train.py \
                --device 1 \
                --hyp hyp.fullaugadam-new.yaml \
                --optimizer 'Adam' \
                --name 'fullaugAdam-new' \
                --img 960 \
                --batch 16 \
                --epochs 1200 \
                --data CaDaBo-11/data.yaml \
                --weights yolov5m.pt \
                --bbox_interval 1 \
                --save-period 120
        ;;
    *)
        echo "Invalid task ID: $SLURM_ARRAY_TASK_ID"
        exit 1
        ;;
esac
