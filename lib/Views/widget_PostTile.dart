import 'package:flutter/material.dart';
import 'package:instagramapp/Views/widget_Post.dart';

class PostTile extends StatelessWidget {

  final Post post;

  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector
    (
      child:Image.network(post.url)
    );
    
  }
}