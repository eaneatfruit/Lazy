#!/usr/bin/python

import string

# Declare static variables
inserts = ", tcp/"
period = "."

def parse(ips, inserts, lineList):
   # Opens text file and strips new line and leading tabs, and iterates through every line
   lineList = [line.rstrip('\n').lstrip('\t') for line in open('test.txt')]

   length = len(lineList)
   for i in range(length):
      # If there is a period in that line, save the IP, and print line
      if period in lineList[i]:
          s = lineList[i].split()
          ips = s[0]
          print(lineList[i].replace('\t',', tcp/'))
      # Otherwise, add the IP and manually insert strings
      else:
          print("{0}{1}{2}".format(ips, inserts, lineList[i]))

def main():
   ips = list()
   lineList = list()
   parse(ips, inserts, lineList)

# Initializes main function
if __name__ == '__main__':
   main()







