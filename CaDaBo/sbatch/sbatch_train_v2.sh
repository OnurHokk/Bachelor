#!/bin/bash
#SBATCH --job-name="train yolov5"
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50G
#SBATCH --partition=gpu
#SBATCH --gpus=4
#SBATCH --array=1-4
#SBATCH --output=logs/CaDaBo-2/train_new_%A_%a.log
#SBATCH --error=logs/CaDaBo-2/train_new_error_%A_%a.log
#SBATCH --chdir=/work/ws-tmp/g022788-bachelor/yolov5/

eval "$(conda shell.bash hook)"
conda activate bachelor

export COMET_API_KEY="262SXJpiFMwChydRzzwhGNGTT"
export COMET_PROJECT_NAME="CaDaBo-New"
export COMET_LOG_PER_CLASS_METRICS=true


case $SLURM_ARRAY_TASK_ID in
    1)
        HYPERPARAMS="hyp.scratch-low.yaml"
        name="random-splits-low"
        data="CaDaBo-2-1"
        img=960
        ;;
    2)
        HYPERPARAMS="hyp.scratch-high.yaml"
        name="random-splits-high"
        data="CaDaBo-2-1"
        img=960
        ;;
    3)
        HYPERPARAMS="hyp.scratch-low.yaml"
        name="random-nodisplay-low"
        data="CaDaBo-2-2"
        img=960
        ;;
    4)
        HYPERPARAMS="hyp.scratch-high.yaml"
        name="random-nodisplay-low"
        data="CaDaBo-2-2"
        img=960
        ;;
    5)
        HYPERPARAMS="hyp.scratch-high.yaml"
        name="random-640-low"
        data="CaDaBo-2-3"
        img=640
        ;;
    6)
        HYPERPARAMS="hyp.scratch-high.yaml"
        name="bmw-display"
        data="CaDaBo-2-4"
        img=960
        ;;
    7)
        HYPERPARAMS="hyp.scratch-high.yaml"
        name="bmw-nodisplay"
        data="CaDaBo-2-5"
        img=960
        ;;
    8)
        HYPERPARAMS="hyp.scratch-high.yaml"
        name="citroen"
        data="CaDaBo-2-6"
        img=960
        ;;
    9)
        HYPERPARAMS="hyp.scratch-high.yaml"
        name="citroen-augs"
        data="CaDaBo-2-9"
        img=960
        ;;
    10)
        HYPERPARAMS="hyp.scratch-high.yaml"
        name="citroen-nostretch"
        data="CaDaBo-2-7"
        img=960
        ;;
    11)
        HYPERPARAMS="hyp.scratch-high.yaml"
        name="citroen-nostretch-augs"
        data="CaDaBo-2-8"
        img=960
        ;;
    *)
        echo "Invalid task ID: $SLURM_ARRAY_TASK_ID"
        exit 1
        ;;
esac

# Calculate the GPU ID based on task ID
# This will keep the GPU ID within the range [0, 3] for the available GPUs
GPU_ID=$((($SLURM_ARRAY_TASK_ID - 1) % 4))

# Set GPU devices to use the calculated GPU ID
export CUDA_VISIBLE_DEVICES=$GPU_ID

echo "running task $SLURM_ARRAY_TASK_ID ($name) on gpu $CUDA_VISIBLE_DEVICES"

comet python train.py \
        --batch 12 \
        --epochs 5 \
        --device $CUDA_VISIBLE_DEVICES \
        --hyp $HYPERPARAMS \
        --name $name \
        --img $img \
        --patience 0 \
        --data "$data/data.yaml" \
        --weights yolov5m.pt \
        --bbox_interval 1 > "logs/CaDaBo-2/$name.log" 2>&1 &
