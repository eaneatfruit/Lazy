#!/usr/bin/python3

import requests
import json

API_ENDPOINT = "http://127.0.0.1:8080/v1/json/"

def curl():
    with open('emails.txt') as f:
        lines = [line.rstrip() for line in f]
        for emails in lines:
            r = requests.get(url = API_ENDPOINT + emails)
            data = json.loads(r.content)
            validemails = str(data['address'])
            deliverable = str(data['deliverable'])
            
            if deliverable is 'True':
                print(validemails)

def main():
    curl()

# Initializes the main function
if __name__ == '__main__':
   main()


