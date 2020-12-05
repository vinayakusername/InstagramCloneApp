import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/Model/model_user.dart';
import 'package:instagramapp/Views/widget_EditProfilePage.dart';
import 'package:instagramapp/Views/widget_HomePage.dart';
import 'package:instagramapp/Views/widget_ReuseableAppBar.dart';

class ProfilePage extends StatefulWidget {

   final String userProfileId;
   ProfilePage({this.userProfileId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

   String currentOnlineUserId = currentUser.id;

  createProfileTopView()
  {
    return FutureBuilder
    (
      future: userReference.document(widget.userProfileId).get(),
      builder:(context,dataSnapshot)
      {
         if(!dataSnapshot.hasData)
         {
            return Center(child: CircularProgressIndicator());
         }

         User user = User.fromDocument(dataSnapshot.data);
         return Padding
         (
           padding: EdgeInsets.all(17.0),
           child: Column
           (
             children: <Widget>
             [
               Row
               (
                  children: <Widget>
                  [
                    CircleAvatar
                    (
                      radius: 45.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(user.url),
                    ),
                    Expanded
                    ( 
                      flex:1,
                      child: Column
                      (
                        children: <Widget>
                        [
                          Row
                          (
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>
                            [
                              createColumns('posts',0),
                              createColumns('followers',0),
                              createColumns('following',0)
                            ],
                          ),

                          Row
                          (
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>
                            [
                              createButtons()
                            ],
                          )
                          
                        ],
                      )
                    ),
                  ],
               ),

               Container
               (
                 alignment: Alignment.centerLeft,
                 padding: EdgeInsets.only(top:13.0),
                 child: Text
                 (
                   user.username,
                   style: TextStyle(fontSize:14.0,color:Colors.black,),
                 ),
               ),

                Container
               (
                 alignment: Alignment.centerLeft,
                 padding: EdgeInsets.only(top:5.0),
                 child: Text
                 (
                   user.profileName,
                   style: TextStyle(fontSize:18.0,color:Colors.black,),
                 ),
               ),

                Container
               (
                 alignment: Alignment.centerLeft,
                 padding: EdgeInsets.only(top:5.0),
                 child: Text
                 (
                   user.bio,
                   style: TextStyle(fontSize:14.0,color:Colors.black,),
                 ),
               ),
             ],
           ),
         );
      }
    );
  }


  Column createColumns(String title,int count)
  {
      return Column
      (
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>
        [
          Text
          (
            count.toString(),
            style: TextStyle(fontSize:20.0,color:Colors.black,fontWeight: FontWeight.bold),
          ),
          Container
          (
            margin: EdgeInsets.only(top:5.0),
            child: Text
            (
              title,
              style:TextStyle(fontSize:16.0,color:Colors.black,fontWeight: FontWeight.w300)
            ),
          )
        ],
      );
  }

  createButtons()
  {
    bool ownProfile = currentOnlineUserId == widget.userProfileId;
    if(ownProfile)
    {
      return createButtonTitleAndFunction(title:'Edit Profile',performFunction: editUserProfile);
    }
  }

  Container createButtonTitleAndFunction({String title,Function performFunction})
  {
     return Container
     (
       padding: EdgeInsets.only(top:3.0),
       child: FlatButton
       (
         onPressed: performFunction, 
         child: Container
         (
           width: 200.0,
           height: 26.0,
           child: Text
           (
             title,
             style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold) ,
           ),
           alignment: Alignment.center,
           decoration: BoxDecoration
           (
             color: Colors.pink,
             border: Border.all(color:Colors.white),
             borderRadius: BorderRadius.circular(6.0)
           ),
           
         )
       ),
     );
  }

  editUserProfile()
  {
    Navigator.push(context,MaterialPageRoute
                           (
                             builder: (context)=>EditProfilePage(currentOnlineUserId:currentOnlineUserId)
                           ));
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold
    (
       appBar: header(context,strTitle: "Profile"),
       body:ListView
       (
         children: <Widget>
         [
           createProfileTopView()
         ],
       )
    );
  }
}