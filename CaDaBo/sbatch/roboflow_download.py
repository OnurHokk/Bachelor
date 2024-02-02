# dataset with citroen cars in test split for generalisation experiment with 960px

from roboflow import Roboflow
rf = Roboflow(api_key="CmkPncwo7RqoVbRtH71I")
project = rf.workspace("onurbachelor").project("cadabo-2")

for i in range(1, 10):
    dataset = project.version(i).download("yolov5")
