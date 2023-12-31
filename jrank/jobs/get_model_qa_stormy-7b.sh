#!/bin/bash 
#SBATCH --job-name=qa_stormy
#SBATCH --account=passaglia
#SBATCH --time=2-00:00:00
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH --cpus-per-task=6
#SBATCH --output=/home/passaglia/slurm/R-%x.%j.out
#SBATCH --error=/home/passaglia/slurm/R-%x.%j.err

source ~/.bashrc
conda activate jrank

export CUDA_DEVICE_ORDER=PCI_BUS_ID
export CUDA_VISIBLE_DEVICES=4

EVAL_DIR=/home/passaglia/projects/jrank/jrank

OUTPUTS_DIR=$EVAL_DIR

python $EVAL_DIR/get_model_qa.py \
    --model_path cyberagent/open-calm-7b \
    --lora_path izumi-lab/stormy-7b-10ep \
    --model_id izumi-lab/stormy-7b-10ep \
    --conv_template $EVAL_DIR/templates/stormy.json \
    --question_file $EVAL_DIR/questions/rakuda_v1.jsonl \
    --answer_file $EVAL_DIR/answers/rakuda_v1/stormy.jsonl \
    --max_new_tokens 256 \
    --repetition_penalty 1.1 \
    --load_8bit False  > $OUTPUTS_DIR/stormy.out 2> $OUTPUTS_DIR/stormy.err
