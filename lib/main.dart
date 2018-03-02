// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:practice/ACMAnnouncements.dart';
import 'package:practice/ACMAnnouncementViewer.dart';
import 'package:practice/ACMHome.dart';
import 'package:practice/GetIp.dart';
import 'package:practice/RandomWords.dart';

class TabbedAppBarSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.green),
      home: new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: const Text('John\'s Sample'),
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
              return
                chosenActivity(choice.title);
            }).toList(),
          ),
        ),
      ),

    );
  }

  StatefulWidget chosenActivity(item){
    if(item == 'Words'){
      return new RandomWords();
    }
    if('ACM Announcements' == item){
      return new ACMAnnouncements();
    }
    if('ACM Home' == item){
      return new ACMHome();
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
  const Choice(title: 'Words', icon: Icons.favorite ),
  const Choice(title: 'IP Address', icon: Icons.web),
  const Choice(title: 'ACM Announcements', icon: Icons.view_list),
  const Choice(title: 'ACM Home', icon: Icons.home),


];


void main() {
  runApp(new TabbedAppBarSample());
}