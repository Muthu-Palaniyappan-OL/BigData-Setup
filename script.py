import requests
import time
import os

const topics = ['BigData', 'DataScience', 'CEG']
count = 0

while True:
	time.sleep(3)
	r = requests.get("https://api.twitter.com/2/tweets/search/recent?query="+topics[count % len(topics)]+"&max_results=20", headers={'Authorization': 'Bearer ' + os.environ.get('BEARER_TOKEN')})
	print(r.text)
	count += 1
