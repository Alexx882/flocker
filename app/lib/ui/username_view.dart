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
          "Wer bist du?",
          style: TextStyle(
            color: const Color.fromRGBO(45, 49, 66, 1),
          ),
        ),
      ),
      body: Center(
        child: Card(
          color: const Color.fromRGBO(168, 249, 255, .8),
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
                        "Sag uns einen Namen!",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Wie heißt du? Unter diesem Namen wirst du dann auch anderen angezeigt.",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    TextFormField(
                      cursorColor: const Color.fromRGBO(45, 49, 66, 1),
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          color: const Color.fromRGBO(45, 49, 66, 1),
                        ),
                        focusColor: const Color.fromRGBO(45, 49, 66, 1),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: const Color.fromRGBO(45, 49, 66, 1),
                        )),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: const Color.fromRGBO(45, 49, 66, 1),
                        )),
                      ),
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
                              color: const Color.fromRGBO(45, 49, 66, 1),
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
