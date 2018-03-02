import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;

class ACMHome extends StatefulWidget {
  @override
  createState() => new ACMHomeState();
}

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class ACMHomeState extends State<ACMHome> {

  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return new Column (children: <Widget>[
      new Container(
        constraints: new BoxConstraints.expand(
          height: 200.0,
        ),
        padding: const EdgeInsets.all(8.0),
        color: Colors.teal.shade700,
        alignment: Alignment.topCenter,
        foregroundDecoration: new BoxDecoration(
          image: new DecorationImage(
            fit: BoxFit.fill,
            image: new NetworkImage(
                'https://rowanacm.org/img/bannerBackgroundSmall.jpg'),
          ),
        ),

      ),
      new Padding(padding: new EdgeInsets.only(top: 20.0),
          child:
          new MaterialButton(onPressed: _handleSignIn,
            color: Colors.blue, child:
            new Text('Meeting Sign-in',
                style: new TextStyle(
                  fontFamily: "Rock Salt",
                  fontSize: 17.0,
                  color: Colors.orange,
                )
            ),
          )
      ),
      new Padding(padding: new EdgeInsets.all(20.0), child:
      new Text(
          'What is ACM?\nACM is the programming club at Rowan University. I don\'t know what else to put here so please open a pull request and add more info here.\n\nWhen do you meet?\nEvery Friday at 2–4 PM in Robinson 201 a/b.',
          style: new TextStyle(
            fontFamily: "Rock Salt",
            fontSize: 17.0,
          )
      )
      )
    ],

    );
  }


  //google sign in stuff

  Future<Null> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
  }

  Future<Null> _handleSignIn() async {
    print('sign in pressed');
    try {
      await _googleSignIn.signIn();
      print('singed in');
    } catch (error) {
      print(error);
    }
  }

  Future<Null> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

}