from flask import Flask, request, jsonify
from flask_restful import Resource, Api, reqparse


from geopy.distance import great_circle

app = Flask(__name__)
api = Api(app)

gpsData = {}

wien = (48.12, 16.22)

klagenfurt = (46.617778, 14.305556)
aau = (46.616095, 14.265383)


# Define parser and request args
parser = reqparse.RequestParser()

parser.add_argument('lat', type=float)
parser.add_argument('long', type=float)
parser.add_argument('time', type=str)

class GPSList(Resource):
    def get(self):
        return great_circle(klagenfurt, wien).km

    def post(self):

        args = parser.parse_args()

        lat = args['lat']
        long = args['long']
        time = args['time']

        pos = (lat, long)

        gc = great_circle(pos, aau).km
        if gc < 0.5:
            return jsonify(distance=gc)
        else:
            return jsonify(distance="not university")

api.add_resource(GPSList, '/')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
