import io
from flask import request, Response
from db.repository import Repository
from db.dynamodb_repository import DynamoDbRepository
from db.entities.user_cluster import UserCluster
from processing.clusterer import Clusterer
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas

repo = DynamoDbRepository.get_instance()

def get():
    locations = repo.get_popular_locations()
    return [l.to_serializable_dict() for l in locations]
