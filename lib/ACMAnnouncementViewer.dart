import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practice/ACMAnnouncements.dart';
import 'package:practice/Utils.dart';

class ACMAnnouncementViewer extends StatefulWidget {
  ACMAnnouncementViewer(this.announcement);
  final Announcement announcement;
  @override
  createState()  => new ACMAnnouncementViewerState(announcement);
}

class ACMAnnouncementViewerState extends State<ACMAnnouncementViewer> {
  ACMAnnouncementViewerState(this.announcement);
  Announcement announcement;
  String _announcementId;


  @override
  Widget build(BuildContext context) {
    getAnnouncement(_announcementId);
    print(announcement.timestamp);
    DateTime postDate = new DateTime.fromMillisecondsSinceEpoch(announcement.timestamp * 1000, isUtc: true).toLocal();
    var spacer = new SizedBox(height: 32.0);
    var main = new Scaffold (
      appBar: new AppBar(
        title: new Row(children: <Widget>[
          new Padding(padding: new EdgeInsets.all(10.0), child:
      getCachedNetworkImage(announcement.iconUrl)),
          new Text(announcement.committee),
        ]),
      ),
      body: makeScrollable(new Padding(padding: new EdgeInsets.all(20.0), child:
          new Column( children: <Widget>[
              new Center(child: new Text(
                      announcement.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: new TextStyle(fontFamily: "Rock Salt",
                          fontSize: 27.0,fontWeight: FontWeight.bold),
                      )
              ),
              new Container(
                padding: const EdgeInsets.only(top:8.0),
                alignment: Alignment.topRight,
                child: new Text(
                      '${postDate.month}-${postDate.day}-${postDate.year}'),
              )
              ,
              new Padding(padding: new EdgeInsets.only(top:8.0),
                  child: new Text(announcement.text,
                          style: new TextStyle(
                          fontFamily: "Rock Salt",
                          fontSize: 17.0,
                        ),
                  ),
              )
            ])
          )
      )
      );
    return main;
  }

  void getAnnouncement(String announcementId) {
    
    
  }

}