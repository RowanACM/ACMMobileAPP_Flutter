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
  var changing_committee = false;
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
      ),new Padding(padding: new EdgeInsets.all(20.0),
          child:
          _build_committee_picker()
      ),
      new Padding(padding: new EdgeInsets.all(20.0), child:
      new Directionality(
          textDirection: TextDirection.ltr,
          child: new Text( _toDoListToString(_profileJson['todo_list']),
              style: new TextStyle(
                fontFamily: "Rock Salt",
                fontSize: 17.0,
              )
          ))
      ),


    ],

    ): new Text('please log in to view profile.');
  }
  String _toDoListToString(todoList){
    String list ='Todo list: \n \t';
    for(var item in todoList){
      list += item['text'] + ' ' + ((item['completed:'])? '' :'✓') + '\n\t';
    }
    return list;
  }

  Future<Null> _committee_picker() async {
    await showDialog<String>(
      context: context,
      child: new SimpleDialog(
        title: const Text('Select Committee'),
        children: _committeChoices()
        ,
      ),
    ).then((String committee){ print(committee);_changeCommittee(committee);});
  }

  Widget _build_committee_picker(){


    return
      new RaisedButton(onPressed: _committee_picker, child:
      new Center( child:
      ((changing_committee)?
      const CupertinoActivityIndicator()
          :
      new Text('Committee: ' + ((_profileJson!= null && _profileJson['committee_string'] != null)? _profileJson['committee_string'] : '' )))));
  }

  List<Widget> _committeChoices(){
    var committeeSelection = new List<Widget>();
    for(Committee committee in committees){
      committeeSelection.add(new SimpleDialogOption(
        onPressed: () {Navigator.pop(context,committee.value); },
        child: new Text(committee.name),
      ));
    }
    return committeeSelection;
  }


  //meeting sign in stuff
  Future _getProfileInfo()async {
    try {
      if (_profileJson == null || changing_committee) {
        if (fireUser != null) {
          fireUser.getIdToken(refresh: true).then((String idToken) async {
            var result;
            String url = 'https://api.rowanacm.org/prod/get-user-info?token=' +
                idToken;
            this.idToken = idToken;
            get(url).then((var data) {
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
    }catch(e){

    }
  }
  _changeCommittee(String committee) {
    String url = 'https://api.rowanacm.org/prod/set-committees?token=' +
        idToken + '&committees=general,' + committee;
    print('url '+url);
    if (mounted) {
      setState(() {
        changing_committee = true;
      });
    }
    get(url).then((response){
      _getProfileInfo().then((repsonse){
        if (mounted) {
          setState(() {
            changing_committee = false;
          });
        }});

    });

  }
}

class Department {
}

