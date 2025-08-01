#!/usr/bin/env bash

# catch arguments
ROOT_DIR=${1}
CONDA_DIR=${2}
CLS_THRESH=${3}
ECO_PATH=${4}
IMG_DIR=${5}
SMOOTH_BOOL=${6}

# set MPS functionality for silicon computing
if [ "$(uname)" == "Darwin" ]; then
    export PYTORCH_ENABLE_MPS_FALLBACK=1
fi

# change directory
cd "${ROOT_DIR}"

# set variables
BS_ENV="${CONDA_DIR}/envs/ecoassistcondaenv-base"
DF_ENV="${CONDA_DIR}/envs/ecoassistcondaenv-pytorch"
MODEL_PATH="${ROOT_DIR}/models/namibian_desert/namib_desert_v1.pt"
JSON_PATH="${IMG_DIR}/image_recognition_file.json"

# activate conda env for classification
source "${CONDA_DIR}/etc/profile.d/conda.sh"
source "${CONDA_DIR}/bin/activate" base
export PATH="${CONDA_DIR}/bin":$PATH
conda deactivate
conda activate "${DF_ENV}"

# add ecoassist folder to path
export PATH="${ECO_PATH}:${ECO_PATH}/cameratraps:$PATH"
export PYTHONPATH="$PYTHONPATH:${ECO_PATH}:${ECO_PATH}/cameratraps:${ECO_PATH}/yolov5"

# run script
python "${ECO_PATH}/EcoAssist/classification_utils/model_types/addax-yolov8/classify_detections.py" "${ROOT_DIR}" "${MODEL_PATH}" "0.1" "${CLS_THRESH}" "${SMOOTH_BOOL}" "${JSON_PATH}" "None"

# switch back to base env
conda deactivate
conda activate "${BS_ENV}"
