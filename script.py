import requests
import time
import os

while True:
	time.sleep(3)
	r = requests.get("https://api.twitter.com/2/tweets/search/recent?query=BigData&max_results=100", headers={'Authorization': 'Bearer ' + os.environ.get('BEARER_TOKEN')})
	print(r.text)