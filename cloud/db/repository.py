from db.location_datastore import LocationDatastore
from db.entities.location import Location
from typing import List, Dict
import json

class Repository:
    def __init__(self):
        self.store = LocationDatastore.get_instance()

    def addLocation(self, location):
        self.store.add(location)

    def getLocations(self) -> List[Location]:
        with open('db/data.json', 'r') as f:
            return [Location(ld) for ld in json.loads(f.read())]
        # return self.store.get()
