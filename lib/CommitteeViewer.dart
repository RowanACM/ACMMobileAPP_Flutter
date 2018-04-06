import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practice/ACMAnnouncements.dart';
import 'package:practice/Committees.dart';
import 'package:practice/Utils.dart';
import 'package:practice/Committee.dart';
class CommitteeViewer extends StatefulWidget {
  CommitteeViewer(this.committee);
  final Committee committee;
  @override
  createState()  => new CommitteeViewerState(committee);
}

class CommitteeViewerState extends State<CommitteeViewer> {
  CommitteeViewerState(this.committee);
  Committee committee;
  String _announcementId;


  @override
  Widget build(BuildContext context) {
    getAnnouncement(_announcementId);
    var main = new Scaffold (
      appBar: new AppBar(
        title: new Row(children: <Widget>[
          new Padding(padding: new EdgeInsets.all(10.0), child:
          getCachedNetworkImage(committee.iconUrl)),
          new Text(committee.name),
        ]),
      ),
      body: makeScrollable(new Padding(padding: new EdgeInsets.all(25.0),
                  child: new Text(committee.description,
                          textAlign: TextAlign.justify,
                          style: new TextStyle(
                          fontFamily: "Rock Salt",
                          fontSize: 17.0,
                        ),
                  ),
              )


      ));
    return main;
  }

  void getAnnouncement(String announcementId) {
    
    
  }

}