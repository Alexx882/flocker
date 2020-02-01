import json
from datetime import datetime


class Location:
    def __init__(self, location_info=None, ):
        super().__init__()
        if location_info is not None:
            self.id = location_info['id']
            self.latitude = location_info['latitude']
            self.longitude = location_info['longitude']
            self.timestamp = datetime.fromtimestamp(location_info['timestamp'])
            self.username = location_info['username']

    def to_serializable_dict(self):
        return {
            "id": self.id,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "timestamp": self.timestamp.__str__(),
            "username":  self.username
        }

    def __repr__(self):
        return json.dumps(self.to_serializable_dict())

    def __str__(self):
        return f"Location({self.__repr__()})"
