import io
from flask import request, Response
from db.repository import Repository
from magic.clusterer import Clusterer
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas

repo = Repository()
clusterer = Clusterer()

def get():
    locations = repo.getLocations()
    labels = clusterer.start(locations)
    
    return labels

def getImage():
    locations = repo.getLocations()

    labels = clusterer.start(locations)
    fig = clusterer.print_locations(locations, labels)

    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)

    return Response(output.getvalue(), mimetype="image/png")