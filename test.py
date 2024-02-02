import time
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

def rising_call(channel):
  print("rising edge")

def falling_call(channel):
  print("falling edge")

button = 4

GPIO.setup(button, GPIO.IN, GPIO.PUD_DOWN)
GPIO.add_event_detect(button, GPIO.RISING, callback=rising_call, bouncetime=500)  
#GPIO.add_event_detect(button, GPIO.FALLING, callback=falling_call)  

message=input("press enter to exit\n")

GPIO.cleanup()
