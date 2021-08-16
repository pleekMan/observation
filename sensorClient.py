# ÇA MARCHE !!!

import socket
import random
import time
import RPi.GPIO as GPIO


#----- SERVER CREATE SOCKET (FOR SENDING TO  PROCESSING)

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 12000              # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))

#----- ULTRASONIC SENSOR SETUP

#GPIO Mode (BOARD / BCM)
GPIO.setmode(GPIO.BCM)
 
#set GPIO Pins
GPIO_TRIGGER = 18
GPIO_ECHO = 24
 
#set GPIO direction (IN / OUT)
GPIO.setup(GPIO_TRIGGER, GPIO.OUT)
GPIO.setup(GPIO_ECHO, GPIO.IN)

sensorFreq = 0.25

def getSensorDistance():
    # set Trigger to HIGH
    GPIO.output(GPIO_TRIGGER, True)
 
    # set Trigger after 0.01ms to LOW
    time.sleep(0.00001)
    GPIO.output(GPIO_TRIGGER, False)

    # print("Start Measuring")
    
    StartTime = time.time()
    StopTime = time.time()
 
    # save StartTime
    while GPIO.input(GPIO_ECHO) == 0:
        StartTime = time.time()
        # print("StartTime")
 
    # save time of arrival
    while GPIO.input(GPIO_ECHO) == 1:
        StopTime = time.time()
        # print("StopTime")
 
    # time difference between start and arrival
    TimeElapsed = StopTime - StartTime
    # multiply with the sonic speed (34300 cm/s)
    # and divide by 2, because there and back
    distance = (TimeElapsed * 34300) / 2
 
    return distance

if __name__ == '__main__':
    try:
        while True:
            distance = getSensorDistance()
            #print ("=|| Distance = %.1f cm" % distance)

            #--- SEND
            #s.send("test\n".encode());
            #data = random.randrange(0,1023,1) #start, stop, step
            #data = (str(data)).encode()ç
            
            s.send(str(distance).encode())
            time.sleep(sensorFreq)
 
        # Reset by pressing CTRL + C
    except KeyboardInterrupt:
        print("Measurement stopped by User")
        GPIO.cleanup()
