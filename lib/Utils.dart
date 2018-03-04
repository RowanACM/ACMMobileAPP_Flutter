import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget getCachedNetworkImage(String url){
  return new CachedNetworkImage(
    imageUrl: url,
    placeholder: new CircularProgressIndicator(),
    errorWidget: new Icon(Icons.error),
  );
}



Widget makeScrollable(Widget widget){
  return new SingleChildScrollView(child: widget);
}
