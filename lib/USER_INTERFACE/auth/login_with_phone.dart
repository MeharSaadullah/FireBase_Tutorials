import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/USER_INTERFACE/auth/verify_code.dart';
import 'package:firebase_tutorials/USER_INTERFACE/widgets/roundbutton.dart';
import 'package:firebase_tutorials/utils/utils.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance; // initilazing the firebase in this screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: phoneNumberController,
              decoration: InputDecoration(hintText: '+92 7877 8979'),
            ),
            SizedBox(
              height: 80,
            ),
            RoundButton(
                title: 'login',
                loading: loading,
                ontap: () async {
                  setState(() {
                    loading = true;
                  });

                  //phoneNumber:
                  //phoneNumberController.text;
                  auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,

                      //phoneNumber: phoneNumber,
                      verificationCompleted: (_) {
                        setState(() {
                          loading = false;
                        });
                      },
                      verificationFailed: (e) {
                        setState(() {
                          loading = false;
                        });
                        Utils.flushBarErrorMessage(e.toString(), context);
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyCodeScreen(
                                      verificationId: verificationId,
                                    )));
                        setState(() {
                          loading = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (e) {
                        Utils.flushBarErrorMessage(e.toString(), context);
                        setState(() {
                          loading = false;
                        });
                      });
                })
          ],
        ),
      ),
    );
  }
}
