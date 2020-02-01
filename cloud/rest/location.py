from flask import request, Response
from db.repository import Repository
import json
from db.entities.location import Location
from typing import List

repo = Repository()

def post():
    body = request.json
    repo.addLocation(Location(body))
    return Response(status=201)

def get():
    return [l.to_serializable_dict() for l in repo.getLocations()]
