import 'package:flocker/cluster/model/cluster.dart';
import 'package:flocker/cluster/model/point_of_interest.dart';

abstract class AbstractServerConnection {
  Future<bool> uploadPositionToServer(
      double lat, double long, int timestamp, String username);
  
  Future<List<Cluster>> fetchClustersFromServer();

  Future<List<PointOfInterest>> fetchPointsOfInterestFromServer();  
}
