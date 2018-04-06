import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'package:practice/SessionData.dart';
import 'package:practice/Config/values.dart';
import 'package:practice/Committee.dart';
import 'package:practice/RestUtil.dart';

class Profile extends StatefulWidget {
  @override
  createState() => new ProfileState();
}
enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class ProfileState extends State<Profile> {
  var idToken;
 // GoogleSignInAccount _currentUser;
  var _profileJson = profileInfoCache;
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
            image:  new  CachedNetworkImageProvider(_profileJson['profile_picture']),
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
      new Padding(padding: new EdgeInsets.all(10.0), child:
      new Text('Meetings attened: ${_profileJson['meeting_count']}',
          style: new TextStyle(
            fontFamily: "Rock Salt",
            fontSize: 17.0,
          )
      )
      ),
      new Padding(padding: new EdgeInsets.all(20.0), child:
      new Text('Todo list: \n \t ${_profileJson['todo_list']}',
          style: new TextStyle(
            fontFamily: "Rock Salt",
            fontSize: 17.0,
          )
      )
      ),
      new Padding(padding: new EdgeInsets.all(20.0), child:
        _build_committee_picker()
      ),

    ],

    ): new Text('please log in to view profile.');
  }
  _selection(result){
    print(result);
  }

  Future<Null> _committee_picker() async {
    _changeCommittee (await showDialog<Department>(
      context: context,
      child: new SimpleDialog(
        title: const Text('Select Committee'),
        children: _committeChoices()
        ,
      ),
    ));
  }

  Widget _build_committee_picker(){
    return new RaisedButton(onPressed: _committee_picker, child: new Text('Committee: ' + ((_profileJson!= null && _profileJson['committee_string'] != null)? _profileJson['committee_string'] : '' )));
  }

  List<Widget> _committeChoices(){
    var committeeSelection = new List<Widget>();
    for(Committee committee in committees){
      committeeSelection.add(new SimpleDialogOption(
        onPressed: () {Navigator.pop(context,committee.name); },
        child: new Text(committee.name),
      ));
    }
    return committeeSelection;
  }


  //meeting sign in stuff
   _getProfileInfo()async {
    if(_profileJson == null) {
      String result;
      if (fireUser != null) {
        fireUser.getIdToken(refresh: true).then((String idToken) async {
          String url = 'https://api.rowanacm.org/prod/get-user-info?token=' +
              idToken;
          this.idToken = idToken;
          get(url).then((String data) {
            result = data;
            profileInfoCache = result;
            if (mounted) {
              setState(() {
                _profileJson = result;
              });
            }
            return result;
          });
        });
      }
    }
   }
    _changeCommittee(committee) {
      if (_profileJson == null) {
        String url = 'https://api.rowanacm.org/prod/set-committees?token=' +
            idToken + '&committees=general,' + committee;
        get(url);
      }
    }
}

class Department {
}

