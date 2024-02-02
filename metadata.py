from picamera2 import Picamera2

cam= Picamera2()
cam.start()

metadata=cam.capture_metadata()
print(metadata)
