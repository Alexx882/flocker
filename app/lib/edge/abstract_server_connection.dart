import 'package:flocker/cluster/model/cluster.dart';

abstract class AbstractServerConnection {
  Future<bool> uploadPositionToServer(
      double lat, double long, int timestamp, String username);
  
  Future<List<Cluster>> fetchClustersFromServer();
}
