import json
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import DBSCAN

class Clusterer:
    def __init__(self, epsilon=11, min_points=2):
        self.epsilon = epsilon
        self.min_points = min_points

    def draw_locations(self, locations:list, labels:list) -> plt.Figure:
        return self._draw_locations(
            locations = np.asarray([(l['latitude'], l['longitude']) for l in locations]),
            partition_info = labels
        )

    def _draw_locations(self, locations:np.ndarray=None, centroids:np.ndarray=None, partition_info=None) -> plt.Figure:
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
    
    def create_labels(self, locations:list) -> list:
        if locations is None or len(locations) == 0:
            return locations # trash in trash out

        locations = np.asarray([(l['latitude'], l['longitude']) for l in locations])
    
        dbsc = DBSCAN(eps = self.epsilon, min_samples = self.min_points)
        dbsc = dbsc.fit(locations)
        labels = dbsc.labels_

        return labels.tolist()

    def label_locations(self, locations:list, labels:list) -> list:
        pass