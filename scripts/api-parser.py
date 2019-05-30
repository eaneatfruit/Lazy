#!/usr/bin/python3

import requests
import json
import urllib

# Parse Function
def parse(dictionary, api_string, url):
   
   # Iterate through all dictionary key and values
   for root_call, sub_call in dictionary.items():

      # This checks if the object (sub_call) is a dictionary classinfo, if it is, evaluates to True
      if isinstance(sub_call, dict):
         parse(sub_call, api_string, url)
      else:
         
         # If "/api/" string is found in the sub_call dictionary
         if api_string in sub_call:
            
            # Print the url and the subcall in String format() method
            print("{0}{1}".format(url, sub_call))

# Main Function
def main():

   # Identifies the JSON response string (may vary depending on application)
   api_string = "/api/"

   # Specify the URL that you are sending the GET request to
   url = 'API URL HERE'
   r = requests.get(url)
   apis = json.loads(r.content)
   
   # Run the parse function
   parse(apis, api_string, url)

# Initializes the main function
if __name__ == '__main__':
   main()
