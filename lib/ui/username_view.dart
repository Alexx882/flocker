import 'package:flocker/ui/tracking_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsernameView extends StatefulWidget {
  @override
  _UsernameViewState createState() => _UsernameViewState();
}

class _UsernameViewState extends State<UsernameView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _username;

  void _onSubmit() async {
    if (_formKey.currentState.validate() && !_loading) {
      setState(() {
        _loading = true;
      });

      FocusScope.of(context).requestFocus(FocusNode());
      _formKey.currentState.save();

      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setString("username", _username);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => TrackingView(),
        ),
      );
    }
  }

  void _checkUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey("username"))
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => TrackingView(),
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    _checkUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wer bist du?"),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FractionallySizedBox(
              widthFactor: .7,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Wie heißt du? Unter diesem Namen wirst du dann auch anderen angezeigt.",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Name"),
                      onSaved: (String value) => _username = value,
                      validator: (String value) {
                        String sanitized = value.trim();

                        if (sanitized.isEmpty)
                          return "Es muss ein Name angegeben werden!";

                        return null;
                      },
                    ),
                    FlatButton(
                      onPressed: _onSubmit,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _loading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(width: 8),
                          Text(
                            "Loslegen!",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
