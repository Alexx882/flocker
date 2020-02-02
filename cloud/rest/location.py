from flask import request, Response
from db.dynamodb_repository import DynamoDbRepository
import json
from db.entities.location import Location
from typing import List

repo = DynamoDbRepository.get_instance()

def post():
    body = request.json
    repo.add_location(Location(body))
    return Response(status=201)

def get():
    return [l.to_serializable_dict() for l in repo.get_locations()]
