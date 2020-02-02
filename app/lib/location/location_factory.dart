import 'package:flocker/location/location.dart';
import 'package:sirius/i_dpa_factory.dart';

class LocationFactory extends DPAFactory<LocalLocation> {
  @override
  LocalLocation fromMap(Map<String, dynamic> data) {
    LocalLocation l = LocalLocation();

    l.id = data["id"];
    l.lat = data["lat"];
    l.long = data["long"];
    l.timestamp = data["timestamp"];

    return l;
  }

  @override
  LocalLocation get entity => LocalLocation();
}
