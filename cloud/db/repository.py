from db.dynamodb_repository import DynamoDbRepository
from db.entities.location import Location
from typing import List, Dict
import json

# todo delete this abstraction layer
class Repository:
    def __init__(self):
        self.store = DynamoDbRepository.get_instance()

    def addLocation(self, location: Location):
        self.store.add_location(location)

    def getLocations(self) -> List[Location]:
        with open('db/data.json', 'r') as f:
            return [Location(ld) for ld in json.loads(f.read())]
        # return self.store.get_locations()
