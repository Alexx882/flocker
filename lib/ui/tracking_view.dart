import 'package:flutter/material.dart';
import 'package:cron/cron.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingView extends StatefulWidget {
  @override
  _TrackingViewState createState() => _TrackingViewState();
}

class _TrackingViewState extends State<TrackingView>
    with TickerProviderStateMixin {
  AnimationController _breathingController;
  Animation<double> _breathingAnimation;

  double _breathValue = 0;
  int counter = 0;

  static final String textPrefix = "Du wirst jetzt überwacht.\n";
  String _text = textPrefix;

  static final String helloPrefix = "Hallo,";
  String _name;

  void _setupAnimation() {
    _breathingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _breathingController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reset();
        _breathingController.forward();
      }
    });

    _breathingController.addListener(() {
      setState(() {
        _breathValue = _breathingAnimation.value;
      });
    });

    _breathingController.forward();

    _breathingAnimation = CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInCirc,
    );
  }

  Future<void> _updatePosition() async {
    try {
      LocationData currentLocation = await Location().getLocation();
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

    cron.schedule(Schedule.parse("*/1 * * * *"), _updatePosition);
    _updatePosition();
  }

  void _setupName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      _name = preferences.getString("username");
    });
  }

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _setupCronjob();
    _setupName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 232, 255, 1),
      appBar: AppBar(
        title: Text(
          _name != null ? helloPrefix + " $_name" : "Hallo!",
          style: TextStyle(
            color: Color.fromRGBO(45, 49, 66, 1),
          ),
        ),
      ),
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
              child: Text("Beenden"),
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
