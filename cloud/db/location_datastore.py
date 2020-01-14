from __future__ import annotations

class LocationDatastore:
    '''This Singelton simulates a location database'''
    _instance = None

    @staticmethod 
    def get_instance() -> LocationDatastore:
        if LocationDatastore._instance == None:
            LocationDatastore._instance = LocationDatastore()
        return LocationDatastore._instance

    def __init__(self):
        if LocationDatastore._instance != None:
            raise Exception("This class is a singleton!")

        self.locations = []
    
    def add(self, location):
        self.locations.append(location)

    
    def get(self):
        return self.locations