from processing.clusterer import Clusterer
from db.repository import Repository
from datetime import datetime, timedelta
from typing import List, Dict
from db.entities.location import Location
import statistics
import time

main_loc_clusterer = Clusterer(epsilon=10**-4)
user_clusterer = Clusterer(epsilon=10**-4)

repo = Repository()
all_location_traces = repo.getLocations()

time_slices = list(range(24))


def work():
    # for each date in timestamp list
    dates = {trace.timestamp.date() for trace in all_location_traces}
    for cur_date in dates:
        traces_for_cur_date = [
            trace for trace in all_location_traces if trace.timestamp.date() == cur_date]

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

            for key, vals in cluster_result.items():
                print(
                    f"{cur_date} @ {cur_hour}h-{cur_hour+1}h (Group #{key}): {[v['username'] for v in vals]}")


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


start_time = time.time()
work()
print("--- %s seconds ---" % (time.time() - start_time))
