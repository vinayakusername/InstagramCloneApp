

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/Model/model_user.dart';
import 'package:instagramapp/Views/widget_HomePage.dart';
import 'package:instagramapp/Views/widget_Progress.dart';
//import 'package:instagramapp/Views/widget_ReuseableAppBar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}



class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage> {

   TextEditingController searchTextEditingController=TextEditingController();
   Future<QuerySnapshot> futureSearchResults;


   emptyTheSearchField()
   {
     searchTextEditingController.clear();
   }

   controlSearching(String str)
   {
       Future<QuerySnapshot> allUsers = userReference.where("profileName",isGreaterThanOrEqualTo:str).getDocuments();
       futureSearchResults = allUsers;
   }

   AppBar searchPageHeader()
   {
     return AppBar
     (
        backgroundColor: Colors.pink,
        title: TextFormField
        (
          style: TextStyle(fontSize: 18.0,color:Colors.white),
          controller: searchTextEditingController,
          decoration: InputDecoration
          (
            hintText: "Search here.....",
            hintStyle: TextStyle(color:Colors.white),
            enabledBorder: UnderlineInputBorder
            (
               borderSide: BorderSide(color:Colors.white),
            ),
            focusedBorder: UnderlineInputBorder
            (
               borderSide: BorderSide(color:Colors.white),
            ), 
            filled: true,
            prefixIcon: Icon(Icons.person_pin,color:Colors.white, size:30.0),
            suffixIcon: IconButton(icon: Icon(Icons.clear),color: Colors.white, onPressed: emptyTheSearchField)
          ),
          onFieldSubmitted: controlSearching,
        ),
     );
   }

   Container displayNoSearchResultScreen()
   {
      final Orientation orientation = MediaQuery.of(context).orientation;
        return Container
        (
           child: Center
           (
             child: ListView
             (
               shrinkWrap: true,
               children: <Widget>
               [
                 Icon(Icons.group,color:Colors.black,size:200.0),
                 Text
                 (
                   "Search Users",
                   textAlign: TextAlign.center,
                   style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 45.0),
                 )
               ],
             ),
           ),
        );
   }

  displayUsersFoundScreen()
  {
    return FutureBuilder
    (
      future: futureSearchResults,
      builder: (context,dataSnapshot)
      {
            if(!dataSnapshot.hasData)
            {
              return circularProgress();
            }

            List<UserResults> searchUserResult =[];
            dataSnapshot.data.documents.forEach((document)
            {
              User eachUser = User.fromDocument(document);
              UserResults userResults = UserResults(eachUser);
              searchUserResult.add(userResults);
            });

            return ListView(children: searchUserResult);
      }
    );
  }

   bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
       appBar: searchPageHeader(),
       body: futureSearchResults == null ? displayNoSearchResultScreen() : displayUsersFoundScreen(),
    );
  }
}


class UserResults extends StatelessWidget {

  final User eachUser;
  UserResults(this.eachUser);

  @override
  Widget build(BuildContext context) {
    return Padding
    (
      padding: EdgeInsets.all(3.0),
      child: Container
      (
        color: Colors.white54,
        child: Column
        (
          children: <Widget>
          [
              GestureDetector
              (
                onTap:() => print("Tapped"),
                child: ListTile
                (
                  leading: CircleAvatar
                  (
                    backgroundColor: Colors.black,
                    backgroundImage:NetworkImage(eachUser.url),
                  ),
                  title: Text(
                             eachUser.profileName,
                             style:TextStyle(color:Colors.black,fontSize: 16.0,fontWeight:FontWeight.bold)
                             ),

                 subtitle: Text(
                                 eachUser.username,
                                 style: TextStyle(color: Colors.black,fontSize: 13.0),
                               ),
                ),
              )
          ],
        ),
      ),
    );
  }
}