class Cluster {
  Cluster(this.id, this.date, this.hour, this.friends) {
    _name = id == -1 ? "People alone" : "Cluster #$id";

    int ms = date.millisecondsSinceEpoch;
    ms += hour * 60 * 60 * 1000;

    _orderDate = DateTime.fromMillisecondsSinceEpoch(ms);
  }

  final int id;
  String _name;
  String get name => _name;
  final DateTime date;
  final int hour;
  final List<String> friends;

  DateTime _orderDate;
  DateTime get orderDate => _orderDate;
}
