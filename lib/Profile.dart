import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'package:practice/SessionData.dart';

class Profile extends StatefulWidget {
  @override
  createState() => new ProfileState();
}

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

 // GoogleSignInAccount _currentUser;
  var _currentUser;
  var _profileJson;
  @override
  void initState() {
    super.initState();
    _getProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return (_profileJson != null)? new Column (children: <Widget>[ 
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

            image:  new NetworkImage(_profileJson['profile_picture']),
          ),
        ),

      ),
      new Padding(padding: new EdgeInsets.only(top: 20.0),
          child: new Text(_profileJson['name'],
                style: new TextStyle(
                fontFamily: "Rock Salt",
                fontSize: 17.0,
                color: Colors.green,
                ))
      ),
      new Padding(padding: new EdgeInsets.all(20.0), child:
      new Text(_profileJson['committee_list'],
            style: new TextStyle(
            fontFamily: "Rock Salt",
            fontSize: 17.0,
          )
      )
      ),
    ],

    ): new Text('please log in to view profile.');
  }



  //meeting sign in stuff
   _getProfileInfo()async {
     String result;

     if (fireUser != null) {
       fireUser.getIdToken(refresh: true).then((String idToken) async {
         String url = 'https://api.rowanacm.org/prod/get-user-info?token=' +
             token;

         print(url);
         var httpClient = new HttpClient();
         try {
           var request = await httpClient.getUrl(Uri.parse(url));
           var response = await request.close();
           if (response.statusCode == HttpStatus.OK) {
             var json = await response.transform(UTF8.decoder).join();
             var data = JSON.decode(json);
             result = data;
           } else {
             result =
             'Error Meeting Login:\nHttp status ${response.statusCode}';
           }
         } catch (exception) {
           result = 'Failed Meeting Login';
         }
         print(result);
//      setState(() {
//        _profileJson = result;
//      });


         return result;
       });
     }
   }
}

