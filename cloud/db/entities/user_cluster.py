import json

class UserCluster:
    def __init__(self, date, hour, clusters):
        super().__init__()
        self.date = date
        self.hour = hour
        self.clusters = clusters
        self.id = f'{self.date}-{self.hour}'

    def to_serializable_dict(self, for_db=False):
        return {
            "id": self.id,
            "date": str(self.date),
            "hour": self.hour,
            "clusters": json.dumps(self.clusters) if for_db else self.clusters
        }

    def __repr__(self):
        return json.dumps(self.to_serializable_dict())

    def __str__(self):
        return f"UserCluster({self.__repr__()})"
