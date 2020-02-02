import 'package:flocker/cluster/model/cluster.dart';
import 'package:flocker/edge/abstract_server_connection.dart';

class MockServerConnection extends AbstractServerConnection {
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
      double lat, double long, int timestamp, String username) async {
    print(
        "MOCK - uploading data. username($username), lat($lat), long($long), time($timestamp)");
    await Future.delayed(Duration(milliseconds: 500), () {});
    return true;
  }
}
