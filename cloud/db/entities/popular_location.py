import json

class PopularLocation:
    def __init__(self, date, top_locations: list):
        super().__init__()
        self.date = date
        self.top_locations = top_locations
        self.id = f'{self.date}'

    def to_serializable_dict(self):
        return {
            "id": self.id,
            "date": self.date.__str__(),
            "top-locations": self.top_locations
        }

    def __repr__(self):
        return json.dumps(self.to_serializable_dict())

    def __str__(self):
        return f"PopularLocation({self.__repr__()})"
