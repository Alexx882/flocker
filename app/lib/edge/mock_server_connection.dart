import 'package:flocker/cluster/model/cluster.dart';
import 'package:flocker/cluster/model/point_of_interest.dart';
import 'package:flocker/edge/abstract_server_connection.dart';

class MockServerConnection extends AbstractServerConnection {
  @override
  Future<List<PointOfInterest>> fetchPointsOfInterestFromServer() async {
    await Future.delayed(Duration(milliseconds: 500), () {});

    List<PointOfInterest> points = [];

    points.add(
      PointOfInterest(
          "Platzerl #1", 46.6172, 14.2688, DateTime.parse("2020-01-30")),
    );
    points.add(
      PointOfInterest(
          "Platzerl #2", 46.614, 14.2673, DateTime.parse("2020-01-30")),
    );
    points.add(
      PointOfInterest(
          "Platzerl #3", 46.6154, 14.2642, DateTime.parse("2020-01-30")),
    );

    return points;
  }

  @override
  Future<List<Cluster>> fetchClustersFromServer() async {
    await Future.delayed(Duration(milliseconds: 500), () {});

    List<Cluster> clusters = [];
    clusters.add(
      Cluster(
        -1,
        DateTime.parse("2020-01-31"),
        11,
        ["Mario", "Herrys Katze", "Alex"],
      ),
    );
    clusters.add(
      Cluster(
        0,
        DateTime.parse("2020-01-31"),
        11,
        ["Andreas", "Herrys Katze", "Tina"],
      ),
    );
    clusters.add(
      Cluster(
        1,
        DateTime.parse("2020-01-31"),
        11,
        ["Mario", "Tina"],
      ),
    );

    return clusters;
  }

  @override
  Future<bool> uploadPositionToServer(
    double lat,
    double long,
    int timestamp,
    String username,
  ) async {
    print(
        "MOCK - uploading data. username($username), lat($lat), long($long), time($timestamp)");
    await Future.delayed(Duration(milliseconds: 500), () {});
    return true;
  }
}
