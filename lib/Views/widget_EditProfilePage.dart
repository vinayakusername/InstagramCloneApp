
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/Model/model_user.dart';
import 'package:instagramapp/Views/widget_HomePage.dart';
import 'package:instagramapp/Views/widget_Progress.dart';

class EditProfilePage extends StatefulWidget {

  final String currentOnlineUserId;
  EditProfilePage({this.currentOnlineUserId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  TextEditingController profileNameTextEditingController = TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  bool _bioValid = true;
  bool _profileNameValid = true;

  void initState()
  {
    super.initState();

    getAndDisplayUserInformation();
  }

  getAndDisplayUserInformation() async
  {
    setState(() 
    {
       loading = true;  
    });

    DocumentSnapshot documentSnapshot = await userReference.document(widget.currentOnlineUserId).get();
    user = User.fromDocument(documentSnapshot);

    profileNameTextEditingController.text = user.profileName;
    bioTextEditingController.text = user.bio;

    setState(() 
    {
       loading = false;  
    });
  }

  updateUserData()
  {
    setState(() 
    {
       profileNameTextEditingController.text.trim().length<3 || profileNameTextEditingController.text.isEmpty ? _profileNameValid = false: _profileNameValid = true;

       bioTextEditingController.text.trim().length > 110 ? _bioValid = false: _bioValid= true;  
    });

    if(_profileNameValid && _bioValid)
    {
      userReference.document(widget.currentOnlineUserId).updateData
      ({

         'profileName':profileNameTextEditingController.text,
         'bio': bioTextEditingController.text
      });

      SnackBar successSnackBar = SnackBar(content: Text('Profile has been updated successfully'));
      _scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      key: _scaffoldGlobalKey,
      appBar: AppBar
      (
        backgroundColor: Colors.pink,
        iconTheme: IconThemeData(color:Colors.white),
        title: Text('Edit Profile',style: TextStyle(color:Colors.white),),
        centerTitle: true,
        actions: <Widget>
        [
          IconButton
          (
            icon: Icon(Icons.done,color:Colors.white,size: 30.0,), 
            onPressed: ()=> Navigator.pop(context)
          )
        ],
      ),
      body: loading ? circularProgress() : 
      ListView
      (
        children: <Widget>
        [
          Container
          (
            child: Column
            (
              children: <Widget>
              [
                Padding
                (
                  padding: EdgeInsets.only(top:16.0,bottom:7.0),
                  child: CircleAvatar
                  (
                    radius: 52.0,
                    backgroundImage: NetworkImage(user.url),
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.all(16.0),
                  child: Column
                  (
                    children: <Widget>
                    [
                      createProfileNameTextFormField(),
                      createBioTextFormField()
                    ],
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.only(top:29.0,left:50.0,right:50.0),
                  child: RaisedButton
                  (
                    child: Text
                    (
                      'Update',
                      style: TextStyle(color:Colors.white,fontSize: 10.0),
                    ),
                    color: Colors.pink,
                    onPressed: updateUserData
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.only(top:10.0,left:50.0,right:50.0),
                   child: RaisedButton
                  (
                    child: Text
                    (
                      'LogOut',
                      style: TextStyle(color:Colors.white,fontSize: 10.0),
                    ),
                    color: Colors.pink,
                    onPressed: logOutUser
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }


  logOutUser() async
  {
      await gSignIn.signOut();
      Navigator.push(context, MaterialPageRoute(builder:(context)=> HomePage()));
  }

  Column createProfileNameTextFormField()
  {
    return Column
    (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>
      [
         Padding
         (
           padding: EdgeInsets.only(top:13.0),
           child: Text('Profile Name',style: TextStyle(color:Colors.grey),),
         ),
         TextFormField
         (
           style: TextStyle(color:Colors.black),
           controller: profileNameTextEditingController,
           decoration: InputDecoration
           (
             hintText: 'Write profile name here...',
             enabledBorder: UnderlineInputBorder
             (
               borderSide: BorderSide(color:Colors.grey)
             ),
             focusedBorder: UnderlineInputBorder
             (
               borderSide: BorderSide(color:Colors.white)
             ),
             hintStyle: TextStyle(color: Colors.grey),
             errorText: _profileNameValid ? null:'Profile name is too short'
           ),
         )
      ],
    );
  }

  Column createBioTextFormField()
  {
    return Column
    (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>
      [
         Padding
         (
           padding: EdgeInsets.only(top:13.0),
           child: Text('Bio',style: TextStyle(color:Colors.grey),),
         ),
         TextFormField
         (
           style: TextStyle(color:Colors.black),
           controller: bioTextEditingController,
           decoration: InputDecoration
           (
             hintText: 'Write bio here...',
             enabledBorder: UnderlineInputBorder
             (
               borderSide: BorderSide(color:Colors.grey)
             ),
             focusedBorder: UnderlineInputBorder
             (
               borderSide: BorderSide(color:Colors.white)
             ),
             hintStyle: TextStyle(color: Colors.grey),
             errorText: _bioValid ? null:'Bio is too Long'
           ),
         )
      ],
    );
  }
}