from db.location_datastore import LocationDatastore

class Repository:
    def __init__(self):
        self.store = LocationDatastore.get_instance()

    def addLocation(self, location):
        self.store.add(location)

    def getLocations(self):
        return self.store.get()
