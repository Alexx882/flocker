from flask import Flask, request, jsonify, render_template, make_response
from flask_restful import Resource, Api, reqparse
import requests
from flask_caching import Cache
from geopy.distance import great_circle
import datetime
import time
import random
from random import randrange, choice
import sys
import json

cache = Cache(config={'CACHE_TYPE': 'simple'})

app = Flask(__name__)
cache.init_app(app)
api = Api(app)

gpsData = {}

aau = (46.616095, 14.265383)


# for generating dummy data
locations = {
    "S": [46.615749, 14.265226],
    "buffet": [46.616204, 14.264926],
    "V": [46.616900, 14.263303],
    "UW": [46.617586, 14.267912],
    "N": [46.616622, 14.264594],
    "HS B": [46.615625, 14.264455],
    "HS C": [46.615654, 14.265050],
    "S 269": [46.615851, 14.265954],
    "IW": [46.615064, 14.262086],
    "Z 108": [46.616078, 14.264292]
    }
usernames = {
    "anja": ["UW", "HS C", "S 269", "buffet"],
    "herry": ["UW", "HS C", "S 269", "buffet", "IW"],
    "alex": ["UW", "HS C", "S 269", "buffet", "IW"],
    "tina": ["buffet", "V", "N"],
    "bibi": ["buffet", "V", "N", "UW"],
    "mario": ["N", "buffet", "HS B", "Z 108"],
    "herrys katze": ["UW"],
    "andreas": ["IW", "buffet", "S 269", "Z 108"],
    "toni": ["S", "IW", "HS B", "buffet"],
    "claudia": ["S 269", "HS B", "Z 108", "N"],
    "daniel": ["N", "HS B", "HS C", "buffet", "UW"],
    "paul": ["UW", "IW"],
    "lena": ["S", "buffet", "HS B", "Z 108"]
    }

def generate_data():
    generated_data = []
    startDate = datetime.datetime(2020, 1, 27, 0, 0)
    for user in usernames:
        for day in range(5):
            for hour in range(9, 13):
                for appearance in range(randrange(0, min(len(usernames[user]), 4))):
                    curr = startDate + datetime.timedelta(days=day, hours=hour, minutes=randrange(60))
                    timestamp = int(time.mktime(curr.timetuple()))
                    timestampFormatted = curr.strftime("%c")
                    random_location = locations[choice(usernames[user])]
                    lat = random_location[0] + random.uniform(-0.0004, 0.0004)
                    long = random_location[1] + random.uniform(-0.0004, 0.0004)


                    filterAndPostData(lat, long, timestamp, user)

                    data = {
                        'lat': lat,
                        'long': long,
                        'time': timestampFormatted,
                        'username': user
                    }

                    generated_data.append(data)
    return generated_data

# Define parser and request args
parser = reqparse.RequestParser()

parser.add_argument('latitude', type=float)
parser.add_argument('longitude', type=float)
parser.add_argument('timestamp', type=float)
parser.add_argument('username', type=str)

@cache.cached(timeout=3600, key_prefix='cluster_results')
def getClusterResults():
     r = requests.get('http://ec2-3-16-29-237.us-east-2.compute.amazonaws.com:5000/api/cluster', headers = {'Accept': 'application/json'})
     return json.loads(r.content)

def filterAndPostData(lat, long, timestamp, username):
    pos = (lat, long)

    gc = great_circle(pos, aau).km
    if gc < 0.5:
        locationData = json.dumps({"latitude": lat, "longitude": long, "timestamp": timestamp, "username": username})
        r = requests.post('http://ec2-3-16-29-237.us-east-2.compute.amazonaws.com:5000/api/location', data = locationData,
            headers = {'Content-type': 'application/json', 'Accept': 'text/html'})
        return jsonify(distance=gc)
    else:
        return jsonify(distance="not university")

class GPS(Resource):

    def get(self):
        r = getClusterResults()
        return str(r)


    def post(self):

        args = parser.parse_args()

        lat = args['latitude']
        long = args['longitude']
        timestamp = args['timestamp']
        username = args['username']

        return filterAndPostData(lat, long, timestamp, username)


class GPSData(Resource):

    def get(self):
        generatedData = generate_data()

        return generatedData

class GPSClusters(Resource):

    def get(self):
        headers = {'Content-Type': 'text/html'}
        r = getClusterResults()
        return make_response(render_template('clusters.html', hours=r),200,headers);

api.add_resource(GPS, '/')
api.add_resource(GPSData, '/data')
api.add_resource(GPSClusters, '/clusters')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
