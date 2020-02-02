import io
from flask import request, Response
from db.dynamodb_repository import DynamoDbRepository
from db.entities.user_cluster import UserCluster
from processing.clusterer import Clusterer
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas

repo = DynamoDbRepository.get_instance()

def get():
    clusters = repo.get_user_clusters()
    return [c.to_serializable_dict() for c in clusters]

def get_image():
    return Response(status=501)

    # locations = repo.getLocations()

    # fig = clusterer.draw_locations(locations)

    # output = io.BytesIO()
    # FigureCanvas(fig).print_png(output)
    # return Response(output.getvalue(), mimetype="image/png")