import 'package:flocker/edge/abstract_server_connection.dart';
import 'package:flocker/edge/mock_server_connection.dart';
import 'package:flocker/ui/cluster_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tracking_view.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  String _name;
  TabController _tabController;
  final AbstractServerConnection serverConnection = MockServerConnection();

  void _setupName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      _name = preferences.getString("username");
    });
  }

  @override
  void initState() {
    super.initState();
    _setupName();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_name != null ? "Hello, $_name" : "Hello"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.location_on)),
              Tab(icon: Icon(Icons.map)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            TrackingView(_tabController, this, serverConnection),
            ClusterView(serverConnection),
          ],
        ),
      ),
    );
  }
}
