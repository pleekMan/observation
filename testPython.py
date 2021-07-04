# ÇA MARCHE !!

import socket
import random
import time

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 12000              # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))

while True:
	#s.send("test\n".encode());
	data = random.randrange(0,1023,1) #start, stop, step
	data = (str(data)).encode()
	s.send(data)
	time.sleep(0.5)
