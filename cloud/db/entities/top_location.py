import json

class TopLocation:
    def __init__(self, top_loc_info=None):
        super().__init__()
        if top_loc_info is not None:
            self.date = top_loc_info['date']
            self.time = top_loc_info['time']
            self.top_locations = top_loc_info['top-locations']
            self.id = f'{self.date}-{self.time}'

    def to_serializable_dict(self):
        return {
            "id": self.id,
            "date": self.date,
            "time": self.time,
            "top-locations": self.top_locations
        }

    def __repr__(self):
        return json.dumps(self.to_serializable_dict())

    def __str__(self):
        return f"TopLocation({self.__repr__()})"
