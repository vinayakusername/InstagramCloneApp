import 'dart:async';
import 'package:flutter/material.dart';
import 'package:instagramapp/Views/widget_ReuseableAppBar.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;


  submitUsername()
  {
    final form = _formKey.currentState;
    if(form.validate())
    {
      form.save();
      SnackBar snackBar = SnackBar(content: Text("Welcome" +username));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 4), (){Navigator.pop(context,username);});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
       key: _scaffoldKey,
       appBar: header(context,strTitle: "Settings",disappearedBackButton: true),
       body: ListView
       (
         children: <Widget>
         [
           Container
           (
             child: Column
             (
               children: <Widget>
               [
                 Padding(
                         padding: EdgeInsets.only(top: 26.0),
                         child: Center
                         (
                           child: Text("Set up a username",style:TextStyle(fontSize:26.0)),
                         ),
                        ),

                 Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Container
                          (
                            child: Form
                            (
                              key: _formKey,
                              autovalidate: true,
                              child: TextFormField
                                    (
                                      style: TextStyle(color:Colors.black),
                                      validator: (val)
                                      {
                                        if(val.trim().length<5||val.isEmpty)
                                        {
                                          return "Username is very short";
                                        }
                                        else if(val.trim().length>15)
                                        {
                                          return "Too long username";
                                        }
                                        else
                                        {
                                             return null;
                                        }
                                      },

                                      onSaved: (val)=> username = val,
                                      decoration: InputDecoration
                                      (
                                        enabledBorder: UnderlineInputBorder
                                        (
                                          borderSide: BorderSide(color:Colors.grey)
                                        ),
                                        focusedBorder: UnderlineInputBorder
                                        (
                                          borderSide: BorderSide(color:Colors.pink)
                                        ),
                                        border: OutlineInputBorder(),
                                        labelText: "Username",
                                        labelStyle: TextStyle(fontSize:16.0),
                                        hintText: "username must be of 5 character",
                                        hintStyle: TextStyle(color:Colors.grey)
                                      ),
                                    )
                            ),
                          ),
                        ),
                      
                      Padding
                      (
                        padding: EdgeInsets.all(5.0),
                        child:RaisedButton
                      (
                        shape: RoundedRectangleBorder
                                      (
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.pink)
                                      ),
                        child: Text("Proceed",style:TextStyle(color:Colors.white,fontSize:20.0)),
                       //textColor: Colors.white,
                        color: Colors.pink,
                        onPressed: submitUsername,
                      ),
                      )     
               ],
             ),
           )
         ],
       ),
    );
  }
}