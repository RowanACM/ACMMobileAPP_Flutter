// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:practice/ACMAnnouncements.dart';
import 'package:practice/ACMAnnouncementViewer.dart';
import 'package:practice/ACMHome.dart';
import 'package:practice/Committees.dart';
import 'package:practice/GetIp.dart';
import 'package:practice/Profile.dart';
import 'package:practice/RandomWords.dart';
import 'package:practice/Utils.dart';


class TabbedAppBarSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.green),
      home: new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: const Text('ACM'),
            bottom: new TabBar(
              isScrollable: true,
              tabs: choices.map((Choice choice) {
                return new Tab(
                  text: choice.title,
                  icon: new Icon(choice.icon),
                );
              }).toList(),
            ),
          ),
          body: new TabBarView(
            children: choices.map((Choice choice) {
              return  chosenActivity(choice.title);

            }).toList(),
          ),
        ),
      ),

    );
  }

  Widget chosenActivity(item){
    if(item == 'Words'){
      return new RandomWords();
    }
    if('ACM Announcements' == item){
      return new ACMAnnouncements();
    }
    if('ACM Home' == item){
      return  makeScrollable(new ACMHome());
    }
    if('Profile' == item){
      return makeScrollable(new Profile());
    }
    if('Committes' == item){
      return new Committes();
    }
    return new GetIp();

  }
}




class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'ACM Home', icon: Icons.home),
  const Choice(title: 'ACM Announcements', icon: Icons.announcement),
  const Choice(title: 'Committes', icon: Icons.view_list),
  const Choice(title: 'Profile', icon: Icons.account_circle),
  const Choice(title: 'Words', icon: Icons.favorite ),
  const Choice(title: 'IP Address', icon: Icons.web),
];


void main() {
  runApp(new TabbedAppBarSample());
}