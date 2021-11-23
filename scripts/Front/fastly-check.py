#!/usr/bin/python3

import socket
from urllib import parse

lineList = [line.rstrip('\n').lstrip('\t') for line in open('Fastly.txt')]
length = len(lineList)
for i in range(length):
    try:
       print(lineList[i] + ":" + socket.gethostbyname(lineList[i]))
    except socket.gaierror as e:
       continue
