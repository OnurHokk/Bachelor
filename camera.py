from time import sleep
import datetime

from picamera2 import Picamera2, Preview
import RPi.GPIO as GPIO
from libcamera import Transform, controls

#import logging
from cysystemd import journal
import uuid

# camera setup
camera = Picamera2()
config = camera.create_still_configuration(
    lores={"size": (1296, 972)},
    display="lores",
    transform=Transform(hflip=0, vflip=0),
)
# camera.set_controls({"AfMode": controls.AfModeEnum.Continuous})

# systemd logging config
#logging.basicConfig(level=logging.INFO)
#logger = logging.getLogger()
#logger.addHandler(journal.JournaldLogHandler())

previewStarted = 0


# callback: take photo when button pressed
def button_callback(channel):
    global previewStarted
    # first press to just start preview
    if previewStarted == 0:
        #logger.info("first press")
        camera.configure(config)
        camera.start_preview(
            Preview.QTGL,
            x=50,
            y=50,
            width=800,
            height=600,
        )
        camera.start()
        previewStarted = 1

    else:
        print("Button pressed, taking photo...")
        # get current time for file name
        time = datetime.datetime.now().strftime("%Y.%m.%d-%H.%M.%S")
        filename = "/home/pi/Bachelor/img/" + time + ".png"
        camera.capture_file(filename, format="png")
        print("Photo saved to: " + filename + " !")  #

        # systemd logging for service
        #logger.info("Photo saved to: " + filename + " !")


# def testCallback(channel):
#   print("Button event called")

GPIO.setmode(GPIO.BOARD)  # use physical board pin numbers

# setup pin 7 (GPIO 4) as input and initial low
pinButton = 7
GPIO.setup(pinButton, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
# add callback to pin on rising edge
GPIO.add_event_detect(
    pinButton, GPIO.RISING, callback=button_callback, bouncetime=10000
)

# while True:
#     try:
#         sleep(60)
#         camera.stop_preview()
#         first_press = 0
#     except:
#         print("exiting...")
#         camera.stop()
#         GPIO.cleanup()
#         break

try:
    while True:
        sleep(600)
        if previewStarted == 1:
            camera.stop_preview()
            previewStarted = 0
except:
    print("exiting...")
    camera.stop()
    GPIO.cleanup()
