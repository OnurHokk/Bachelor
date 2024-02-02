from time import sleep
import datetime

from picamera2 import Picamera2, Preview
import RPi.GPIO as GPIO
from libcamera import Transform, controls

# camera setup
camera = Picamera2()
config = camera.create_still_configuration(
    lores={"size": (1280, 960)},
    display="lores",
    transform=Transform(hflip=1, vflip=1),
)
camera.configure(config)
camera.start_preview(Preview.QTGL, x=400, y=300, width=800, height=600)
camera.start()
sleep(30)
# camera.capture_file("img/test_preview.png")
