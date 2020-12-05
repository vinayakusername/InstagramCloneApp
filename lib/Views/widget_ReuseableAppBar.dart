import 'package:flutter/material.dart';

AppBar header(context,{bool isAppTitle = false,String strTitle,disappearedBackButton=false})
{
  return AppBar
  (
    iconTheme: IconThemeData
    (
      color: Colors.white
    ),
    automaticallyImplyLeading: disappearedBackButton ? false : true,
    title: Text
           (
             isAppTitle ? "Instagram App" : strTitle,
             style: TextStyle
             (
               color: Colors.white,
               fontSize: isAppTitle ? 24.0: 20.0
               //fontFamily: isAppTitle ? "font name" : ""
             ),
             overflow: TextOverflow.ellipsis,
           ),
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColor,
  );
}