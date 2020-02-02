import 'package:flocker/location/location.dart';
import 'package:flocker/location/location_factory.dart';
import 'package:sirius/i_dpa_repository.dart';

class LocationRepository extends DPARepository<LocalLocation, LocationFactory> {
  static LocationRepository _instance;
  static LocationRepository get instance {
    if (_instance == null) _instance = LocationRepository();

    return _instance;
  }

  LocationRepository() : super(LocationFactory());
}
