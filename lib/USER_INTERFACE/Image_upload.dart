//1 st add image picker in yamal 2nd add permissions in ANDRIODManifest.xml which is located in andriod,app,scr,main

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tutorials/USER_INTERFACE/widgets/roundbutton.dart';
import 'package:firebase_tutorials/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  bool loading = false;
  // code to pick image from gallery
  File? _image;
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage
      .instance; // this code is for intilizing storage for upload of image.
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage Storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance
      .ref('Post'); // initlize that table in which we want to store image

  Future getGalleryImage() async {
    final PickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('No image Picked');
      }
    }); //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text('Image Uploader')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getGalleryImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : // this code is for show image on front end
                      Icon(Icons.image),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
                title: 'Upload Image',
                loading: loading,
                ontap: () async {
                  setState(() {
                    loading = true;
                  });
                   firebase_storage.Reference ref = firebase_storage
                       .FirebaseStorage.instance
                       .ref('/Mehar Saadullah' +  // folder name
                          DateTime.now().millisecondsSinceEpoch.toString());
                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);

                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();

                    databaseRef
                        .child('1')
                        .set({'id': '1212', 'title': newUrl.toString()}).then(
                            (value) {
                      setState(() {
                        loading = false;
                      });
                      Utils.flushBarErrorMessage('Uploaded', context);
                    }).catchError((error) {
                      Utils.flushBarErrorMessage(error.toString(), context);
                      setState(() {
                        loading = false;
                      });
                    });
                  });
                })
          ],
        ),
      ),
    );
  }
}
