#!/usr/bin/python3

import requests
import json
import urllib
import string
import base64

# Declare static variables
atsign = "@"

def parse():
   lineList = [line.rstrip('\n') for line in open('users2.txt')]
   length = len(lineList)
   
   for i in range(length):
   # If there is a @ in that line, save IP, save names, and encode the emails
      if atsign in lineList[i]:
         s = lineList[i].split()
         emails = s[0]
         names = s[1] + " " + s[2]
         encodestr = emails
         b = encodestr.encode("UTF-8")
         encode = base64.b64encode(b)
         with open('newfile.txt', 'a') as f:
            f.write(emails + "\t" + names + "\t" + encode + '\n')
 
def main(): 
   parse()

# Initializes main function
if __name__ == '__main__':
   main()

