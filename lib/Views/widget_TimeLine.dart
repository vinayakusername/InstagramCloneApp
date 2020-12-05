import 'package:flutter/material.dart';
import 'package:instagramapp/Views/widget_Progress.dart';
import 'package:instagramapp/Views/widget_ReuseableAppBar.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
         appBar: header(context,isAppTitle: true),
         body: circularProgress()
    );
  }
}