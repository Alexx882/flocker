import 'package:flocker/color_manager.dart';
import 'package:flocker/ui/main_view.dart';
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
          builder: (BuildContext context) => MainView(),
        ),
      );
    }
  }

  void _checkUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey("username"))
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => MainView(),
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
        title: Text(
          "Who are you?",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Card(
          color: ColorManager.colorAnja,
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
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Tell us your name!",
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      // "Wie heißt du? Unter diesem Namen wirst du dann auch anderen angezeigt.",
                      "What's your name? You will be displayed under this name to the other users.",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.white),
                        focusColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                      ),
                      onSaved: (String value) => _username = value,
                      validator: (String value) {
                        String sanitized = value.trim();

                        if (sanitized.isEmpty)
                          return "A name has to be provided!";

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
                            "Start out!",
                            style: TextStyle(
                              color: Colors.white,
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
