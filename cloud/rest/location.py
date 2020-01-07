import io
import base64
from flask import request, Response
from db.repository import Repository
from magic.clusterer import Clusterer
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas

repo = Repository()
clusterer = Clusterer()

def post():
    body = request.json
    repo.addLocation(body)
    return Response(status=201)

def get():
    return repo.getLocations()

def getImage():
    fig = clusterer.start(repo.getLocations())
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)

    return Response(output.getvalue(), mimetype="image/png")