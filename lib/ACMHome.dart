import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

 // GoogleSignInAccount _currentUser;
  var _currentUser;
  String _loginMessage;
  @override
  void initState() {
    super.initState();
    _handleSignInSilently();
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
          child: (_loginMessage != null)?
          new Text(_loginMessage,
                style: new TextStyle(
                fontFamily: "Rock Salt",
                fontSize: 17.0,
                color: Colors.green,
                )) :
          new MaterialButton(onPressed: ()=> _handleSignIn()
              .then((FirebaseUser user) => print(user))
              .catchError((e) => print(e)),
            color: Colors.blue, child:
            new Text(_currentUser == null ? 'Google Sign-in' : 'Meeting Sign-in',
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
      ),
    ],

    );
  }


  //google sign in stuff
  Future<FirebaseUser> _handleSignIn() async {
      return _signIn( await _googleSignIn.signIn());
  }
  Future<FirebaseUser> _handleSignInSilently() async {
    return _signIn( await _googleSignIn.signInSilently());
  }
  Future<FirebaseUser> _signIn(GoogleSignInAccount googleUser) async {
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    setState((){
      _currentUser = user;
    });
      user.getIdToken(refresh:true).then((String idToken){
          _meetingSignIn(idToken);
      });
    return user;
  }



  Future<Null> _handleSignOut() async {
    _googleSignIn.disconnect();
  }


  //meeting sign in stuff
  Future<String> _meetingSignIn(String token)async {

    print(token);
   String  url = 'https://api.rowanacm.org/prod/sign-in?token='+token;
    String result;
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        var data = JSON.decode(json);
        result = data['message'];
      } else {
        result =
        'Error Meeting Login:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed Meeting Login';
    }
    print(result);
    setState(() {
      _loginMessage = result;
    });


   return result;
  }
}