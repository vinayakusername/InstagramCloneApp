import 'package:flutter/material.dart';
import 'package:instagramapp/Views/widget_ReuseableAppBar.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
       appBar: header(context,strTitle: "Notification"),
    );
  }
}