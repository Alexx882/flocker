import 'package:sirius/i_dpa_entity.dart';

class LocalLocation extends DPAEntity {
  int id;
  String lat;
  String long;
  int timestamp;

  @override
  void registerFields() {
    registerField("id", DataType.IntegerAuto, primaryKey: true);
    registerField("lat", DataType.String);
    registerField("long", DataType.String);
    registerField("timestamp", DataType.Integer);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "lat": lat,
      "long": long,
      "timestamp": timestamp,
    };
  }

  @override
  String toString() {
    return "Location($id, $lat, $long, $timestamp)";
  }
}
