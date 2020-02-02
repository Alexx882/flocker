import 'package:flocker/cluster/model/cluster.dart';
import 'package:flocker/edge/abstract_server_connection.dart';
import 'package:flocker/ui/single_cluster_view.dart';
import 'package:flutter/material.dart';

class ClusterView extends StatefulWidget {
  @override
  _ClusterViewState createState() => _ClusterViewState();

  ClusterView(this.serverConnection);

  final AbstractServerConnection serverConnection;
}

class _ClusterViewState extends State<ClusterView> {
  List<Cluster> _clusters;

  void loadClusterData() async {
    List<Cluster> clusters =
        await widget.serverConnection.fetchClustersFromServer();

    setState(() {
      _clusters = clusters;
    });
  }

  @override
  void initState() {
    super.initState();
    loadClusterData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _clusters == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FractionallySizedBox(
                    widthFactor: .3,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CircularProgressIndicator(
                        strokeWidth: 6,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Fetching data from the server...",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemBuilder: (BuildContext context, int k) =>
                  SingleClusterView(_clusters[k]),
              separatorBuilder: (BuildContext context, int k) => FractionallySizedBox(widthFactor: .8,child: Divider()),
              itemCount: _clusters.length,
              padding: EdgeInsets.only(top: 8),
            ),
    );
  }
}
