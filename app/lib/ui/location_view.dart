import 'package:flocker/cluster/model/point_of_interest.dart';
import 'package:flocker/edge/abstract_server_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class LocationView extends StatefulWidget {
  @override
  _LocationViewState createState() => _LocationViewState();

  LocationView(this.serverConnection);

  final AbstractServerConnection serverConnection;
}

class _LocationViewState extends State<LocationView> {
  List<PointOfInterest> _points;

  void loadLocationData() async {
    List<PointOfInterest> clusters =
        await widget.serverConnection.fetchPointsOfInterestFromServer();

    if (mounted)
      setState(() {
        _points = clusters;
      });
  }

  @override
  void initState() {
    super.initState();
    loadLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _points == null
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
          : FlutterMap(
              options: MapOptions(
                center: LatLng(46.6162236, 14.2651012),
                zoom: 17.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://api.tiles.mapbox.com/v4/"
                      "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoibXJoZXJyeSIsImEiOiJjazY1aTl2dXExNnNwM2Zxd24xa2t4dzY3In0.3eXuwdWbJMnioC9O-ByWIQ',
                    'id': 'mapbox.streets',
                  },
                ),
                MarkerLayerOptions(
                  markers: _points
                      .map(
                        (point) => Marker(
                          width: 5,
                          height: 10,
                          point: LatLng(point.lat, point.long),
                          builder: (BuildContext context) =>
                              Icon(Icons.location_on),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
    );
  }
}
