class Repository:
    def __init__(self):
        self.locations = []

    def addLocation(self, location):
        self.locations.append(location)

    def getLocations(self):
        return self.locations
