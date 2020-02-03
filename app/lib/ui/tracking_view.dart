import 'package:battery/battery.dart';
import 'package:flocker/edge/abstract_server_connection.dart';
import 'package:flocker/location/location.dart';
import 'package:flocker/location/location_repository.dart';
import 'package:flutter/material.dart';
import 'package:cron/cron.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingView extends StatefulWidget {
  @override
  _TrackingViewState createState() => _TrackingViewState();

  TrackingView(
      this.parentTabBarController, this.tickerProvider, this.serverConnection);

  final TabController parentTabBarController;
  final TickerProvider tickerProvider;

  final AbstractServerConnection serverConnection;
}

class _TrackingViewState extends State<TrackingView> {
  AnimationController _breathingController;
  Animation<double> _breathingAnimation;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Battery _battery;

  double _breathValue = 0;
  int counter = 0;
  int lastTimeAsked = 0;

  static final String textPrefix = "You are being tracked right now!\n";
  String _text = textPrefix;

  void _setupAnimation() {
    _breathingController = AnimationController(
      vsync: widget.tickerProvider,
      duration: Duration(seconds: 3),
    );

    _breathingController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reset();
        _breathingController.forward();
      }
    });

    _breathingController.addListener(() {
      if (mounted)
        setState(() {
          _breathValue = _breathingAnimation.value;
        });
    });

    _breathingController.forward();

    _breathingAnimation = CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInCirc,
    );

    widget.parentTabBarController.addListener(() {
      bool animationActive = widget.parentTabBarController.index == 0;

      if (animationActive) {
        _breathingController.forward();
      } else {
        _breathingController.stop();
        _breathingController.reset();
      }
    });
  }

  Future<void> _updatePosition() async {
    try {
      LocationData currentLocation = await Location().getLocation();

      LocalLocation l = LocalLocation();
      l.lat = currentLocation.latitude.toString();
      l.long = currentLocation.longitude.toString();
      l.timestamp = DateTime.now().millisecondsSinceEpoch;

      LocationRepository.instance.add(l);

      if (mounted)
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Data was stored successfully."),
            backgroundColor: Colors.green,
          ),
        );

      setState(() {
        _text =
            "$textPrefix ${currentLocation.latitude}/${currentLocation.longitude}";
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _setupCronjob() {
    Cron cron = Cron();

    cron.schedule(Schedule.parse("*/5 * * * *"), _updatePosition);
    _updatePosition();
  }

  void _uploadData() async {
    List<LocalLocation> locations = await LocationRepository.instance.all();
    print("found ${locations.length} stored locations.");
    String name = (await SharedPreferences.getInstance()).getString("username");

    for (LocalLocation l in locations) {
      print("Upload of $l");
      await LocationRepository.instance.delete({"id": l.id});
      await widget.serverConnection.uploadPositionToServer(
        double.parse(l.lat),
        double.parse(l.long),
        l.timestamp,
        name,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _setupCronjob();
    _battery = Battery();
    _battery.onBatteryStateChanged.listen((BatteryState state) async {
      if (state == BatteryState.charging) {
        if (mounted) {
          print("battery status changed.");

          List<LocalLocation> data = await LocationRepository.instance.all();

          if (data.length > 0) {
            if (DateTime.now().millisecondsSinceEpoch >
                lastTimeAsked + 86400000) {
              lastTimeAsked = DateTime.now().millisecondsSinceEpoch;
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text("Upload"),
                  content: Text("Should the data be uploaded now?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _uploadData();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "No",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            } else
              print("wanted to show dialog but have to wait :(");
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromRGBO(234, 232, 255, 1),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // cool animation and text
            FractionallySizedBox(
              widthFactor: .7,
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: <Widget>[
                    // background
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromRGBO(155, 196, 203, 1),
                      ),
                    ),

                    // loading circle
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: _breathValue,
                        heightFactor: _breathValue,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 3,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // text
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Color.fromRGBO(45, 49, 66, 1),
                            size: 60,
                          ),
                          SizedBox(height: 8),
                          Text(
                            _text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Color.fromRGBO(45, 49, 66, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            RaisedButton(
              child: Text("Close"),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
