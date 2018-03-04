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
class Committes extends StatefulWidget {
  @override
  createState() => new CommittesState();
}

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);
const List<Committee> committees = const <Committee>[
  const Committee(name: 'Robotics', description: 'The Robotics committee intends to extend its members\' knowledge and skill by giving them lessons and experience in designing simple circuits, working with common sensors and actuators, and programmatically interacting with physical hardware in a meaningful way.',iconUrl: 'https://firebasestorage.googleapis.com/v0/b/rowan-acm.appspot.com/o/robotics-committee.png?alt=media&token=c3fc8f64-696a-4f83-8c01-f3bdd11bd369'),
  const Committee(name: 'Animation / Game Design', iconUrl: 'https://firebasestorage.googleapis.com/v0/b/rowan-acm.appspot.com/o/game-committee.png?alt=media&token=21c8d9e6-7c15-48be-a045-82c538fcc0c4', description: 'The Robotics committee intends to extend its members\' knowledge and skill by giving them lessons and experience in designing simple circuits, working with common sensors and actuators, and programmatically interacting with physical hardware in a meaningful way.'),
  const Committee(name: 'AI', iconUrl: 'https://firebasestorage.googleapis.com/v0/b/rowan-acm.appspot.com/o/ai-committee.png?alt=media&token=543ac18f-134c-4fe2-a057-9501abe48d85', description: 'The Rowan ACM Artificial Intelligence Team is dedicated to promoting the concepts of AI to new students in CS. Because every student may not take the Artificial Intelligence class offered at Rowan, we would like to give students enough of a background so that they can pursue a greater understanding of the field on their own. We teach new students about basic concepts in AI and then attempt to apply them in useful applications ranging from game playing to problem solving.'),
  const Committee(name: 'Full Stack', iconUrl: 'https://firebasestorage.googleapis.com/v0/b/rowan-acm.appspot.com/o/web-committee.png?alt=media&token=867937e1-5c83-44b7-aac2-15d7fbb418da', description: 'The Fullstack committee is a team of ACM members committed to learning the fundamentals of Full Development through hands-on activities and a collaborative environment. The team consists of individuals possessing a wide range of skills. Though the team is full of potential.'),


];
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








class Committee {
  const Committee({ this.name, this.iconUrl, this.description });
  final String name;
  final String iconUrl;
  final String description;


}

