import 'dart:convert';

import 'package:flocker/cluster/model/cluster.dart';
import 'package:flocker/edge/abstract_server_connection.dart';
import 'package:flocker/cluster/model/point_of_interest.dart';
import 'package:http/http.dart' as http;

class EdgeServerConnection extends AbstractServerConnection {
  final String url = "https://flocker.anja.codes";

  @override
  Future<List<Cluster>> fetchClustersFromServer() async {
    try {
      print(
        "REAL - getting Clusterss.",
      );

      http.Response response = await http.get(
        "$url/clusters",
      );

      if (response.statusCode != 200) {
        print("Server responded with ${response.statusCode}:${response.body}");
        return [];
      }

      List<Cluster> clusters = [];

      for (Map<String, dynamic> clustersOfOneDate
          in jsonDecode(response.body)) {
        DateTime date = DateTime.parse(clustersOfOneDate["date"]);
        int hour = clustersOfOneDate["hour"];

        Map<String, dynamic> actualClusters = clustersOfOneDate["clusters"];

        for (String id in actualClusters.keys) {
          List<dynamic> friends = actualClusters[id];

          List<String> friendList = [];
          for (String friend in friends) friendList.add(friend);

          clusters.add(
            Cluster(int.parse(id), date, hour, friendList),
          );
        }
      }

      clusters.sort(
        (c1, c2) =>
            c2.orderDate.millisecondsSinceEpoch -
            c1.orderDate.millisecondsSinceEpoch,
      );

      return clusters;
    } catch (e) {
      print("$e");
      return [];
    }
  }

  @override
  Future<List<PointOfInterest>> fetchPointsOfInterestFromServer() async {
    try {
      print(
        "REAL - getting POIs.",
      );

      http.Response response = await http.get(
        "$url/locations",
      );

      if (response.statusCode != 200) {
        print("Server responded with ${response.statusCode}:${response.body}");
        return [];
      }

      List<PointOfInterest> pois = [];

      for (Map<String, dynamic> pointsOfOneDate in jsonDecode(response.body)) {
        DateTime date = DateTime.parse(pointsOfOneDate["date"]);

        for (Map<String, dynamic> onePoi in pointsOfOneDate["top-locations"])
          pois.add(PointOfInterest("", onePoi["lat"], onePoi["long"], date));
      }

      // for (PointOfInterest point in pois) print(point);
      // print("${pois.length}");

      return pois;
    } catch (e) {
      print("$e");
      return [];
    }
  }

  @override
  Future<bool> uploadPositionToServer(
      double lat, double long, int timestamp, String username) async {
    try {
      print(
        "REAL - uploading data. username($username), lat($lat), long($long), time($timestamp)",
      );

      Map<String, dynamic> data = {
        "latitude": lat,
        "longitude": long,
        "timestamp": timestamp,
        "username": username,
      };

      http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        print("Server responded with ${response.statusCode}:${response.body}");
        return false;
      }

      return true;
    } catch (e) {
      print("$e");
      return false;
    }
  }
}
