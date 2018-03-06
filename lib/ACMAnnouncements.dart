import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/ACMAnnouncementViewer.dart';
import 'package:practice/SessionData.dart';

import 'package:cached_network_image/cached_network_image.dart';



class ACMAnnouncements extends StatefulWidget {
  @override
  createState()  => new ACMAnnouncementsState();
}

class ACMAnnouncementsState extends State<ACMAnnouncements> {
  var _announcements = (announcementsCache != null)? announcementsCache : <Announcement>[];
  static bool _refreshed = false;
  @override
  Widget build(BuildContext context) {
    getAnnouncements();
    var spacer = new SizedBox(height: 32.0);
    var main = new Scaffold (
      body: _announcements.length > 0 ? _buildAnnouncements() :
    new Center(child:const CupertinoActivityIndicator(),)
      ,
    );
    return main;

  }
  @override
  void initState() {
   // utils.LoadCachedData();
  }
  Future getAnnouncements() async {

    if(_refreshed == false) {
      print('getting');
      var url = 'https://api.rowanacm.org/prod/get-announcements';
      var httpClient = new HttpClient();
      String result = '';
      List announcements = <Announcement>[];
      try {
        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        _announcements.clear();
        print('got');
        _refreshed = true;
        if (response.statusCode == HttpStatus.OK) {
          var json = await response.transform(UTF8.decoder).join();
          SessionUtils.storeAnnouncementsQuery(json);
          var data = JSON.decode(json);
          print('use');
          announcements = Announcement.jsonToAnnouncment(data);
        } else {
          result =
          'Error getting announcements:\nHttp status ${response.statusCode}';
        }
      } catch (exception) {
        _announcements.clear();

        result = 'Failed getting  announcements';
      }
      announcementsCache = announcements;
      if(mounted) {
        setState(() {
          _announcements = announcements;
        });
        return result;
      }
    }
  }



  Widget _buildRow(Announcement anno) {
    return new ListTile(
        leading:  new CachedNetworkImage(imageUrl:anno.iconUrl,
              placeholder: new CircularProgressIndicator(),
              errorWidget: new Icon(Icons.error),
        ),
        title: new Text(
          anno.title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: new Text(anno.text,
            overflow: TextOverflow.ellipsis,
            maxLines: 2
        ),
      onTap: ()=>_pushAnnouncement(anno),
    );
  }
  
  Widget _buildAnnouncements() {


    return new RefreshIndicator(child: new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              if (i.isOdd) return new Divider();
              final index = i ~/ 2;
              if (index < _announcements.length) {
                return _buildRow(_announcements[index]);
              }
            }
    ), onRefresh: _refreshAnnouncments );

  }
  Future _refreshAnnouncments()async{
    _refreshed=false;
     getAnnouncements().then((announcement){
       return announcement;
     });
  }


  void _pushAnnouncement(Announcement _announcement) {
    Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) => new ACMAnnouncementViewer(_announcement),
    ));
  }
   
}








class Announcement {
  const Announcement({ this.title, this.iconUrl, this.text,this.committee,this.timestamp });
  final String title;
  final String iconUrl;
  final String text;
  final String committee;
  final int timestamp;


  static List jsonToAnnouncment(var data){
    List announcements = <Announcement>[];

    for (var announcement in data) {

      announcements.add(
          new Announcement(title: announcement['title'].toString(),
              iconUrl: announcement['icon'],
              text: announcement['snippet'].toString(),
              committee: announcement['committee'].toString(),
              timestamp: announcement['timestamp']
          ));
    }
    return announcements;
  }
}

const List<Announcement> choices = const <Announcement>[
];
