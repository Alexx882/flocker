from flask import Flask, request, jsonify
from flask_restful import Resource, Api, reqparse
import requests
from flask_caching import Cache
from geopy.distance import great_circle
import datetime

cache = Cache(config={'CACHE_TYPE': 'simple'})

app = Flask(__name__)
cache.init_app(app)
api = Api(app)

gpsData = {}

aau = (46.616095, 14.265383)

# Define parser and request args
parser = reqparse.RequestParser()

parser.add_argument('latitude', type=float)
parser.add_argument('longitude', type=float)
parser.add_argument('timestamp', type=float)
parser.add_argument('username', type=str)

@cache.cached(timeout=3600, key_prefix='cluster_results')
def getClusterResults():
     r = requests.get('http://ec2-3-16-29-237.us-east-2.compute.amazonaws.com:5000/api/location')
     return r

class GPSList(Resource):

    def get(self):
        r = getClusterResults()
        return str(r)


    def post(self):

        args = parser.parse_args()

        latitude = args['latitude']
        longitude = args['longitude']
        timestamp = args['timestamp']
        username = args['username']

        pos = (latitude, longitude)

        gc = great_circle(pos, aau).km
        if gc < 0.5:
            locationData = {'latitude': latitude, 'longitude': longitude, 'timestamp': timestamp, 'username': username}
            r = requests.post('http://ec2-3-16-29-237.us-east-2.compute.amazonaws.com:5000/api/location', data = locationData)
            return jsonify(distance=gc)
        else:
            return jsonify(distance="not university")

api.add_resource(GPSList, '/')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
