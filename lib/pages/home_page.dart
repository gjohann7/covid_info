import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
      color: Colors.blueGrey[900],
      child: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Welcome to the",
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                        Text("COVID-19 INFO",
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60.0),
                          child: Text("App",
                              style: TextStyle(
                                fontSize: 45.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                        Column(children: <Widget>[
                          Text("Check the last update",
                              style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.greenAccent[100],
                              )),
                          Text("on the coronavirus",
                              style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.greenAccent[100],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Text("(COVID-19) status",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.greenAccent[100],
                                )),
                          ),
                          Text("Data Source:",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.blueGrey[100])),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'COVID 19 API',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.orange[200]),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch('https://covid19api.com/');
                                    },
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'GO TO WEBSITE',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.orange[200]),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch('https://covid19api.com/');
                                    },
                                ),
                              ],
                            ),
                          ),
                        ])
                      ],
                    ),
                  ]))),
    ));
  }
}
