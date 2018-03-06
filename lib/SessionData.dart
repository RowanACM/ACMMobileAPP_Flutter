import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice/ACMAnnouncements.dart';
import 'package:shared_preferences/shared_preferences.dart';


FirebaseUser fireUser;
String token;
String meetingLoginMessageCache;
var announcementsCache;
var profileInfoCache;
Future<SharedPreferences> prefs =  SharedPreferences.getInstance();

class SessionUtils {
  static void LoadCachedData(){
    print('loading cache');
    getLastAnnouncementsQuery().then((List announcements){
      print(announcements);
      announcementsCache =announcements;
    });
  }

 static String _ANNOUNCEMENTS = 'announcements';
 static Future storeAnnouncementsQuery(String announcement) async {
   print('yup');
   print(announcement);
    prefs.then((SharedPreferences prefs) {
      prefs.setString(_ANNOUNCEMENTS, announcement.toString());
    });
  }

  static Future<List> getLastAnnouncementsQuery()async {
    return await prefs.then((SharedPreferences prefs){
      print('loading in cache announcments');
      var anc = (prefs.getString(_ANNOUNCEMENTS));
      print('got ${anc}');
      return Announcement.jsonToAnnouncment(  new JsonDecoder().convert(anc));
    });

  }
}