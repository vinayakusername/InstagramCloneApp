import 'package:flutter/material.dart';
import 'package:instagramapp/Views/widget_HomePage.dart';
import 'package:instagramapp/Views/widget_Post.dart';
import 'package:instagramapp/Views/widget_Progress.dart';
import 'package:instagramapp/Views/widget_ReuseableAppBar.dart';

class PostScreenPage extends StatelessWidget {

  final String postId;
  final String userId;


  PostScreenPage({this.postId,this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder
    (
      future:postReference.document(userId).collection('usersPosts').document(postId).get(),
      builder: (context,dataSnapshot)
      {
        if(!dataSnapshot.hasData)
        {
          return circularProgress();
        }
        
      
       Post post = Post.fromDocument(dataSnapshot.data);
       return Center
       (
         child: Scaffold
         (
           appBar: header(context,strTitle: post.description),
           body: ListView
           (
             children: <Widget>
             [
               Container
               (
                 child: post,
               )
             ],
           ),
         ),
       );
      },
    );
  }
}