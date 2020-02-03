import 'package:flocker/cluster/model/cluster.dart';
import 'package:flutter/material.dart';

class SingleClusterView extends StatelessWidget {
  final Cluster cluster;
  bool _noCluster = false;

  SingleClusterView(this.cluster) {
    _noCluster = this.cluster.id == -1;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .7,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "${cluster.name}",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: _noCluster ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    "${cluster.date.toIso8601String().substring(0, 10)} ${cluster.hour < 10 ? 0 : ''}${cluster.hour}:00",
                    style: TextStyle(
                      color: _noCluster ? Colors.grey : Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: cluster.friends
                    .map(
                      (String f) => Text(
                        f,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: _noCluster ? Colors.grey : Colors.black,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
