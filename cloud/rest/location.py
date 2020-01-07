from flask import request, Response
from db.repository import Repository
repo = Repository()

def post():
    body = request.json
    repo.addLocation(body)
    return Response(status=201)

def get():
    return repo.getLocations()