#!/usr/bin/python

import pymongo
conn = pymongo.MongoClient('127.0.0.1', 27017)

# This is the database name
db = conn['credentials']

# This is the collection name
col = db.user 

cur = col.find() 
cur

for doc in cur:
   print doc["username"] + ":" + doc["password"]
 
