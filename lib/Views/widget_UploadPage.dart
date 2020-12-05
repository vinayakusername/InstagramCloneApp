
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/Model/model_user.dart';
import 'package:instagramapp/Views/widget_HomePage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget {

  final User gCurrentUser;
  UploadPage({this.gCurrentUser});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>{

  File file;
  bool postUploading = false;
  String postId = Uuid().v4();

  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  captureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage
                (
                  source: ImageSource.camera,
                  maxHeight: 680,
                  maxWidth: 970
                );
      setState(() 
      {
             this.file = imageFile;  
      });
  }

   pickImageFromGallery() async {
        Navigator.pop(context);
        File imageFile = await ImagePicker.pickImage
                         (
                           source: ImageSource.gallery
                          );
         setState(() 
         {
            this.file = imageFile;  
         });
   }


  takeImage(mContext)
  {
       return showDialog
       (
         context: mContext,
         builder: (context)
         {
            return SimpleDialog
            (
              title: Text(
                           "New Post",
                           style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
                          ),
              children: <Widget>
              [
                SimpleDialogOption
                (
                  child: Text("Capture Image with Camera",style:TextStyle(color:Colors.black)),
                  onPressed: captureImageWithCamera,
                ),

                 SimpleDialogOption
                (
                  child: Text("Select Image from Gallery",style:TextStyle(color:Colors.black)),
                  onPressed: pickImageFromGallery,
                ),

                 SimpleDialogOption
                (
                  child: Text("Cancel",style:TextStyle(color:Colors.black)),
                  onPressed:()=> Navigator.pop(context),
                ),
              ],
            );
         }
       );
  }



  displayUploadScreen()
  {
    return Container
    (
      
      child: Column
      (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>
        [
          Icon(Icons.add_photo_alternate,color: Colors.grey,size: 200.0,),
          Padding
          (
            padding: EdgeInsets.only(top:20.0),
            child: RaisedButton
            (
              shape: RoundedRectangleBorder
                                      (
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.pink)
                                      ),
              child: Text("Upload Image",style:TextStyle(color:Colors.white,fontSize:20.0)),
              //textColor: Colors.white,
              color: Colors.pink,
              onPressed:()=> takeImage(context)
            ),

          ),
        ],
      ),
    );
  }

 clearPostInfo()
 {
   locationTextEditingController.clear();
   descriptionTextEditingController.clear();
   setState(() 
   {
      file = null;  
   });
 }
  

  getUserCurrentLocation() async
  {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placeMarks = await Geolocator().placemarkFromCoordinates(position.latitude,position.longitude);
      Placemark mPlaceMark = placeMarks[0];
      String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare},${mPlaceMark.subLocality} ${mPlaceMark.locality},${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country} ';
      String specificAddress = '${mPlaceMark.locality},${mPlaceMark.country}';
      locationTextEditingController.text = specificAddress;
  }

 compressPhoto() async
 {
   final tDirectory = await getTemporaryDirectory();
   final path = tDirectory.path;
   ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
   final compressImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(ImD.encodeJpg(mImageFile,quality: 90));
   setState(() 
   {
      file = compressImageFile;  
   });
 }

 
  controlUploadingAndSave() async
  {
    setState(() 
    {
      postUploading = true;  
    });

    await compressPhoto();

    String downloadUrl = await uploadPhoto(file);

    savePostInfoToFirestore(url:downloadUrl,location:locationTextEditingController.text,description:descriptionTextEditingController.text);
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();

    setState(() 
    {
       file = null;
       postUploading = false;
       postId = Uuid().v4();  
    });
  }
 
   savePostInfoToFirestore({String url,String location,String description})
   {
      postReference.document(widget.gCurrentUser.id).collection('usersPosts').document(postId).setData
      ({
        'postId':postId,
        'ownerId':widget.gCurrentUser.id,
        'timeStamp': timeStamp,
        'likes':{},
        'username': widget.gCurrentUser.username,
        'url':url,
        'location':location,
        'description':description
      });
   }


 Future<String> uploadPhoto(mImageFile) async
  {
      StorageUploadTask mStorageUploadTask = storageReference.child('post_$postId.jpg').putFile(mImageFile);
      StorageTaskSnapshot storageTaskSnapshot = await mStorageUploadTask.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadUrl;
  }

 displayUploadFormScreen()
 {
   return Scaffold
   (
     appBar: AppBar
     (
       backgroundColor: Colors.pink,
       leading: IconButton
       (
         icon: Icon(Icons.arrow_back,color:Colors.white), 
         onPressed: clearPostInfo
       ),
       title: Text
       (
         'New Post',
         style:TextStyle
         (
           fontSize: 24.0,
           color:Colors.white,
           fontWeight: FontWeight.bold
         )
       ),
       actions: <Widget>
       [
         FlatButton
         (
           child: Text('Share',style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.white)),
           onPressed: postUploading ? null : () => controlUploadingAndSave(), 
           
         )
       ],
     ),
     body: ListView
     (
       children: <Widget>
       [
         postUploading ? LinearProgressIndicator():Text(''),
         Container
         (
           height: 230.0,
           width: MediaQuery.of(context).size.width * 0.8,
           child: Center
           (
             child: AspectRatio
             (
               aspectRatio: 16/9,
               child:Container
               (
                 decoration: BoxDecoration(image:DecorationImage(image: FileImage(file),fit:BoxFit.cover)),
               )
             ),
           ),
         ),
         Padding
         (
           padding: const EdgeInsets.only(top:12.0)
         ),
         ListTile
         (
           leading: CircleAvatar(backgroundImage: NetworkImage(widget.gCurrentUser.url),),
           title: Container
           (
             width: 250.0,
             child: TextField
             (
               style: TextStyle(color:Colors.black),
               controller: descriptionTextEditingController,
               decoration: InputDecoration
               (
                 hintText: 'Say Something about image...',
                 hintStyle: TextStyle(color: Colors.black),
                 border: InputBorder.none
               ),
             ),
           ),
         ),
         Divider(),
         ListTile
         (
           leading: Icon(Icons.person_pin_circle,color:Colors.black,size:36.0),
           title: Container
           (
             width: 250.0,
             child: TextField
             (
               style: TextStyle(color:Colors.black),
               controller: locationTextEditingController,
               decoration: InputDecoration
               (
                 hintText: 'Write the location here...',
                 hintStyle: TextStyle(color: Colors.black),
                 border: InputBorder.none
               ),
             ),
           ),
         ),

         Container
         (
           width: 220,
           height: 110,
           alignment: Alignment.center,
           child: RaisedButton.icon
           (
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
             color: Colors.pink, 
             icon: Icon(Icons.location_on,color: Colors.white,), 
             label: Text('Get My Current Location',style:TextStyle(color:Colors.white)),
             onPressed: getUserCurrentLocation,
           )
          
         )
       ],
     ),
   );
 }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return file == null? displayUploadScreen(): displayUploadFormScreen();
  }
}