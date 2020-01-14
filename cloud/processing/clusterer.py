import json
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import DBSCAN
from typing import List, Dict

class Clusterer:
    def __init__(self, epsilon=11, min_points=2):
        self.epsilon = epsilon
        self.min_points = min_points

    def draw_locations(self, locations:List, labels:List=None) -> plt.Figure:
        if locations is None or len(locations) == 0:
            return self._draw_locations()

        if labels is None or len(locations) != len(labels):
            labels = self.create_labels(locations)

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
    
    def create_labels(self, locations:List) -> List:
        if locations is None or len(locations) == 0:
            return locations # trash in trash out

        locations = np.asarray([(l['latitude'], l['longitude']) for l in locations])
    
        dbsc = DBSCAN(eps = self.epsilon, min_samples = self.min_points)
        dbsc = dbsc.fit(locations)
        labels = dbsc.labels_

        return labels.tolist()

    def label_locations(self, locations:List[Dict], labels:List) -> List:
        if len(locations) != len(labels):
            raise Exception("locations and labels has to have same length")

        for i in range(len(locations)):
            locations[i]['cluster_label'] = labels[i]

    def run(self, locations:List[Dict]) -> Dict[int, List[Dict]]:
        if locations is None or len(locations) == 0:
            # raise Exception("locations has to contain something")
            return {}

        labels = self.create_labels(locations)
        self.label_locations(locations, labels)

        clusters = {}
        for label in labels:
            clusters[label] = [l for l in locations if l['cluster_label'] == label]
        
        return clusters