class PointOfInterest {
  final String title;
  final double lat;
  final double long;
  final DateTime date;

  PointOfInterest(this.title, this.lat, this.long, this.date);

  @override
  String toString() {
    return "POI(@$lat,$long,15z)";
  }
}
