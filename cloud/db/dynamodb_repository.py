from __future__ import annotations
import boto3
from decimal import Decimal
from db.entities.location import Location
from db.entities.user_cluster import UserCluster
from db.entities.popular_location import PopularLocation
from typing import List, Dict
import json


class DynamoDbRepository:
    '''This Singelton accesses AWS DynamoDB'''
    _instance: DynamoDbRepository = None

    @staticmethod
    def get_instance() -> DynamoDbRepository:
        if DynamoDbRepository._instance == None:
            DynamoDbRepository._instance = DynamoDbRepository()
        return DynamoDbRepository._instance

    def __init__(self):
        if DynamoDbRepository._instance != None:
            raise Exception("This class is a singleton!")

        self.database = boto3.resource('dynamodb', region_name='us-east-2')

    def add_location(self, location: Location):
        '''Inserts a location to the Location table of AWS'''
        table = self.database.Table('Location')
        table.put_item(
            Item={
                "id": location.id,
                "latitude": Decimal(f'{location.latitude}'),
                "longitude": Decimal(f'{location.longitude}'),
                "timestamp": location.timestamp_raw,
                "username": location.username
            }
        )

    def get_locations(self) -> List[Location]:
        '''Reads all locations from the Location table of AWS'''
        table = self.database.Table('Location')
        response = table.scan()
        return [Location(l) for l in response['Items']]

    def add_user_cluster(self, user_cluster: UserCluster):
        '''Inserts a user cluster to the UserCluster table of AWS'''
        table = self.database.Table('UserCluster')
        table.put_item(
            Item=user_cluster.to_serializable_dict(for_db=True)
        )

    def get_user_clusters(self) -> List[UserCluster]:
        '''Reads all user clusters from the UserCluster table of AWS'''
        table = self.database.Table('UserCluster')
        response = table.scan()
        return [UserCluster(c['date'], int(c['hour']), json.loads(c['clusters'])) for c in response['Items']]

    def add_popular_location(self, popular_location: PopularLocation):
        '''Inserts a popular location to the PopularLocation table of AWS'''
        table = self.database.Table('PopularLocation')
        table.put_item(
            Item=popular_location.to_serializable_dict(for_db=True)
        )

    def get_popular_locations(self) -> List[PopularLocation]:
        '''Reads all popular locations from the PopularLocation table of AWS'''
        table = self.database.Table('PopularLocation')
        response = table.scan()
        return [PopularLocation(l['date'], json.loads(l['top-locations'])) for l in response['Items']]
