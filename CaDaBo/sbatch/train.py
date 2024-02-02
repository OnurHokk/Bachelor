# dataset with citroen cars in test split for generalisation experiment with 960px
import torch
import os

from roboflow import Roboflow
rf = Roboflow(api_key="CmkPncwo7RqoVbRtH71I")
project = rf.workspace("onurbachelor").project("cadabo")
dataset = project.version(11).download("yolov5")

import comet_ml
os.environ["COMET_API_KEY"]="262SXJpiFMwChydRzzwhGNGTT"
comet_ml.init(project_name="CaDaBoV3-citroen-960")

#!env COMET_LOG_PER_CLASS_METRICS=true python train.py --hyp hyp.scratch-high.yaml --img 960 --batch -1 --epochs 600 --data {dataset.location}/data.yaml --weights yolov5m.pt --bbox_interval 1 --save-period 50
