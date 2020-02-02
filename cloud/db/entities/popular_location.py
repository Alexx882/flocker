import json

class PopularLocation:
    def __init__(self, date, top_locations: list):
        super().__init__()
        self.date = date
        self.top_locations = top_locations

    def to_serializable_dict(self, for_db=False):
        return {
            "date": str(self.date),
            "top-locations": json.dumps(self.top_locations) if for_db else self.top_locations
        }

    def __repr__(self):
        return json.dumps(self.to_serializable_dict())

    def __str__(self):
        return f"PopularLocation({self.__repr__()})"
