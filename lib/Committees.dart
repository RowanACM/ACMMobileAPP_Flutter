import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'package:practice/CommitteeViewer.dart';
import 'package:practice/SessionData.dart';
import 'Utils.dart';
import 'package:practice/Committee.dart';
import 'package:practice/Config/values.dart';
class Committes extends StatefulWidget {
  @override
  createState() => new CommittesState();
}

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class CommittesState extends State<Committes> {

  @override
  Widget build(BuildContext context) {
    var main = new Scaffold (
      body:  _buildCommitteesList(),
    );
    return main;

  }







  Widget _buildCommitteesList() {


    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i < committees.length) {
            return _buildRow(committees[i]);
          }
        }
    );

  }

  Widget _buildRow(Committee committee) {
    return new Padding(padding: const EdgeInsets.only(bottom: 20.0),
        child: new ListTile(
          leading:  getCachedNetworkImage(committee.iconUrl),
          onTap: ()=>_pushCommittee(committee),
          title: new Text(
            committee.name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: new TextStyle(
                fontFamily: "Rock Salt",
                fontSize: 24.0,
                fontWeight: FontWeight.bold
            ),
          ),
          subtitle: new Text(committee.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            style: new TextStyle(
                fontFamily: "Rock Salt",
                fontSize: 16.0,

            ),
          ),
        )
    );
  }


  void _pushCommittee(Committee _committee) {
    Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) => new CommitteeViewer(_committee),
    ));
  }

}










