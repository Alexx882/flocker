from processing.clusterer import Clusterer
from db.repository import Repository
from db.dynamodb_repository import DynamoDbRepository
from datetime import datetime, timedelta
from typing import List, Dict, Tuple
from db.entities.location import Location
from db.entities.popular_location import PopularLocation
from db.entities.user_cluster import UserCluster
import statistics
from collections import Counter
import time

NR_DECIMAL_FOR_BEST_LOCATIONS = 4

main_loc_clusterer = Clusterer(epsilon=10**-4)
user_clusterer = Clusterer(epsilon=10**-4)

time_slices = list(range(24))

repo = Repository()
dynrepo = DynamoDbRepository.get_instance()

def run_clustering():
    user_clusters: List[UserCluster] = []
    popular_locations: List[PopularLocation] = []
    
    all_location_traces = repo.getLocations()

    # for each date in timestamp list
    dates = {trace.timestamp.date() for trace in all_location_traces}
    for cur_date in dates:
        traces_for_cur_date = [
            trace for trace in all_location_traces if trace.timestamp.date() == cur_date]

        location_counter: Dict[str, int] = {}

        # for each hour of that day
        for cur_hour in time_slices:
            traces_for_time_slice = [
                trace for trace in traces_for_cur_date if trace.timestamp.hour - cur_hour == 0]

            if len(traces_for_time_slice) == 0:
                continue

            main_locations = []

            # store the main location for each user
            usernames = {trace.username for trace in traces_for_time_slice}
            for username in usernames:
                main_loc = get_main_location_for_user(
                    traces_for_time_slice, username)
                main_loc['username'] = username
                main_locations.append(main_loc)

            # cluster the main locations for all users
            cluster_result = user_clusterer.run(main_locations)

            clusters = {}
            for key, vals in cluster_result.items():
                clusters[key] = [v['username'] for v in vals]
                # print(f"{cur_date} @ {cur_hour}h-{cur_hour+1}h (Group #{key}): {[v['username'] for v in vals]}")

            # add the clusters for the cur_hour to the global cluster list
            user_clusters.append(UserCluster(cur_date, cur_hour, clusters))

            # add locations for cur_hour to location counter
            for main_l in main_locations:
                key = {'lat': round(main_l['latitude'], NR_DECIMAL_FOR_BEST_LOCATIONS),
                       'long': round(main_l['longitude'], NR_DECIMAL_FOR_BEST_LOCATIONS)}.__repr__()
                if key not in location_counter:
                    location_counter[key] = 0
                location_counter[key] += 1

            # print(f"{cur_date} @ {cur_hour}h-{cur_hour+1}h: {main_locations}")

        # add the top three locations to the global popular location list
        top_locations = get_top_three_locations(location_counter)
        top_locations = [l[0] for l in top_locations]
        popular_locations.append(PopularLocation(cur_date, top_locations))

    store_user_clusters(user_clusters)
    store_popular_locations(popular_locations)


def get_main_location_for_user(location_traces: List[Location], username: str) -> dict:
    # cluster based on locations
    locations_for_user = [t for t in location_traces if t.username == username]
    clusters = main_loc_clusterer.run([l.__dict__
                                       for l in locations_for_user])

    # largest cluster has most locations
    max_c = {'id': -1, 'size': 0}
    for cluster_key, cluster_vals in clusters.items():
        if len(cluster_vals) > max_c['size']:
            max_c['id'] = cluster_key
            max_c['size'] = len(cluster_vals)

    # calculate center of the location from the largest cluster
    locations_of_largest_cluster = clusters[max_c['id']]
    center = get_center_of_2d_points(locations_of_largest_cluster)
    return center


def get_center_of_2d_points(points, nr_decimal_places=5) -> dict:
    center = {}
    center['latitude'] = round(statistics.mean(
        [p['latitude'] for p in points]), nr_decimal_places)
    center['longitude'] = round(statistics.mean(
        [p['longitude'] for p in points]), nr_decimal_places)
    return center


def get_top_three_locations(location_counts: Dict[str, int]) -> List[Tuple[str, int]]:
    cnter = Counter(location_counts)
    max_three = cnter.most_common(3)
    return max_three


def store_user_clusters(user_clusters: List[UserCluster]):
    for c in user_clusters:
        dynrepo.add_user_cluster(c)


def store_popular_locations(popular_locations: List[PopularLocation]):
    return
    print(popular_locations)


run_clustering()
