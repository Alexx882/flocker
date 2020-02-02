class Cluster {
  Cluster(this.id, this.date, this.hour, this.friends) {
    _name = id == -1 ? "People alone" : "Cluster #$id";
  }

  final int id;
  String _name;
  String get name => _name;
  final DateTime date;
  final int hour;
  final List<String> friends;
}
