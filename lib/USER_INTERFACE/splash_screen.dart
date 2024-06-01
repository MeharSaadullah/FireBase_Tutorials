import 'package:firebase_tutorials/firebase_services/splash_services.dart';
import 'package:flutter/material.dart';

class SplahScreen extends StatefulWidget {
  const SplahScreen({super.key});

  @override
  State<SplahScreen> createState() => _SplahScreenState();
}

class _SplahScreenState extends State<SplahScreen> {
  SplashService splashscreen = SplashService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      splashscreen.islogin(context);
    });
    //  splashscreen.islogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome to FireBase Tutorials Application',
            style: TextStyle(fontSize: 30),
          )
        ],
      ),
    );
  }
}
