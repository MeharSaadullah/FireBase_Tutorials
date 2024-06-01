import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/USER_INTERFACE/Image_upload.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_tutorials/USER_INTERFACE/auth/login_screen.dart';
import 'package:firebase_tutorials/USER_INTERFACE/auth/posts/post_screen.dart';
import 'package:firebase_tutorials/USER_INTERFACE/firestore/firestore_list_screen.dart';
import 'package:flutter/material.dart';

class SplashService {
  void islogin(BuildContext context) {
    final auth = FirebaseAuth
        .instance; // for checking user is already login or not .... initialize fire base in this function
    final user = auth.currentUser; // for checking user is already login or not

    if (user != null) {
      // for checking user is already login or not
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => PostScreen())));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
