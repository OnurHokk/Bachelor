#!/bin/bash

#SBATCH --job-name="train_yolov5"
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=64G
#SBATCH --partition=gpu
#SBATCH --gpus=2
#SBATCH --output=logs/CaDaBo-2/train_new_%j.log
#SBATCH --error=logs/CaDaBo-2/train_new_error_%j.log
#SBATCH --chdir=/work/ws-tmp/g022788-bachelor/yolov5/

eval "$(conda shell.bash hook)"
conda activate bachelor

export COMET_API_KEY="262SXJpiFMwChydRzzwhGNGTT"
export COMET_PROJECT_NAME="CaDaBo-New"
export COMET_LOG_PER_CLASS_METRICS=true

declare -a names=(  "citroen-adam-long"      )
declare -a datas=(  "CaDaBo-2-6"             )
# declare -a imgs=(    960                  
declare -a hyps=(   "hyp.adam-new-slow.yaml" )


    _gpu_script="/work/ws-tmp/g022788-bachelor/bachelor/sbatch/check_gpu.py"

for i in $(seq 0 $(( ${#names[@]} - 1 )))
do
    name=${names[$i]}
    data=${datas[$i]}
    # img=${imgs[$i]}
    img=960
    hyp=${hyps[$i]}

    gpu_assigned=false
    while [ "$gpu_assigned" = false ]; do
        for gpu_id in {0..1}; do
            if python $check_gpu_script $gpu_id check; then
                python $check_gpu_script $gpu_id mark
                export CUDA_VISIBLE_DEVICES=$gpu_id
                echo "Launching task ($name) on gpu $CUDA_VISIBLE_DEVICES"

                comet python train.py \
                    --batch 14 \
                    --epochs 4000 \
                    --optimizer "Adam" \
                    --device $CUDA_VISIBLE_DEVICES \
                    --hyp $hyp \
                    --name $name \
                    --img $img \
                    --patience 0 \
                    --data "$data/data.yaml" \
                    --weights yolov5m.pt \
                    --bbox_interval 1 \
                    --save-period 120 > "logs/CaDaBo-2/$name.log" 2>&1 &
                
                gpu_assigned=true
                break
            fi
        done

        if [ "$gpu_assigned" = false ]; then
            sleep 600  # Wait and retry if all GPUs are busy
        fi
    done

    # Wait for a brief moment before proceeding to the next task
    sleep 15
done

# Wait for all background jobs to finish
wait
