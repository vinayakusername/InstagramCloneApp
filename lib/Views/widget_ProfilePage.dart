import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/Model/model_user.dart';
import 'package:instagramapp/Views/widget_EditProfilePage.dart';
import 'package:instagramapp/Views/widget_HomePage.dart';
import 'package:instagramapp/Views/widget_Post.dart';
import 'package:instagramapp/Views/widget_PostTile.dart';
import 'package:instagramapp/Views/widget_Progress.dart';
import 'package:instagramapp/Views/widget_ReuseableAppBar.dart';

class ProfilePage extends StatefulWidget {

   final String userProfileId;
   ProfilePage({this.userProfileId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> 
{

  String currentOnlineUserId = currentUser.id;
  bool loading = false;
  int countPost = 0;
  List<Post> postsList = [];
  String postOrientation = 'grid';

  void initState()
  {
    super.initState();
    getAllProfilePosts();
  }


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
           createProfileTopView(),
           Divider(),
           createListAndGridPostOrientation(),
           Divider(height:0.0),
           displayProfilePost()
         ],
       )
    );
  }

  displayProfilePost()
  {
    if(loading)
    {
        return circularProgress();
    }

    else if(postsList.isEmpty)
    {
      return Container
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            Padding
            (
              padding: EdgeInsets.all(30.0),
              child: Icon(Icons.photo_library,color:Colors.grey,size:200.0),
            ),

            Padding
            (
              padding: EdgeInsets.only(top: 20.0),
              child: Text("No Posts",style:TextStyle(color:Colors.redAccent,fontSize:40.0,fontWeight:FontWeight.bold)),
            )
          ],
        ),
      );
    }
   
    else if(postOrientation == 'grid')
    {
       List<GridTile> gridTitlesList = [];
       postsList.forEach((eachPost) 
       {
        gridTitlesList.add(GridTile(child: PostTile(eachPost))); 
       });

       return GridView.count
       (
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTitlesList,
       );
    }

     else if(postOrientation == 'list')
    {
      return Column
       (   
         children: postsList,
       );
    }

   
  }

  getAllProfilePosts() async
  {
    setState(() 
    {
      loading = true;  
    });

    QuerySnapshot querySnapshot = await postReference.document(widget.userProfileId)
                                                     .collection("usersPosts")
                                                     .orderBy("timeStamp",descending: true)
                                                     .getDocuments();

   setState(() 
   {
     loading = false;  
     countPost = querySnapshot.documents.length;
     postsList = querySnapshot.documents.map((documentSnapshot) => Post.fromDocument(documentSnapshot)).toList();
   });
  }

  createListAndGridPostOrientation()
  {
     return Row
     (
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: <Widget>
       [
         IconButton
         (
           icon: Icon(Icons.grid_on),
           color: postOrientation == 'grid'? Theme.of(context).primaryColor:Colors.grey, 
           onPressed: () => setOrientation("grid")
         ),
          IconButton
         (
           icon: Icon(Icons.list),
           color: postOrientation == 'list'? Theme.of(context).primaryColor:Colors.grey, 
           onPressed:() => setOrientation("list")
         )
       ],
     );
  }

  setOrientation(String orientation)
  {
    setState(() 
    {
      this.postOrientation = orientation;  
    });
  }


}