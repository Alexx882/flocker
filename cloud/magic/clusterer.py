import json
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import DBSCAN

class Clusterer:
    def __init__(self, epsilon=11, min_points=2):
        self.epsilon = epsilon
        self.min_points = min_points

    def _print_locations(self, locations:np.ndarray=None, centroids:np.ndarray=None, partition_info=None):
        fig = plt.Figure()
        axis = fig.add_subplot(1, 1, 1)

        if locations is not None:
            colors = plt.cm.rainbow(np.linspace(0, 1, len(locations)))

            if partition_info is not None:
                distinct_colors = plt.cm.rainbow(np.linspace(0, 1, len(set(partition_info))))
                colors = [distinct_colors[pi] for pi in partition_info]

            # draw locations with random colors
            axis.scatter(locations[:,0],
                        locations[:,1], 
                        c=colors)

        if centroids is not None:
            # draw black centroids
            axis.scatter(centroids[:,0], centroids[:,1], c='k', marker='x', s=80)
            
        return fig
    
    def start(self, locations:list):
        if locations is None or len(locations) == 0:
            return

        locations = np.asarray([(l['latitude'], l['longitude']) for l in locations])
    
        dbsc = DBSCAN(eps = self.epsilon, min_samples = self.min_points)
        dbsc = dbsc.fit(locations)
        labels = dbsc.labels_

        return self._print_locations(locations, partition_info=labels)
