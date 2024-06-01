import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/USER_INTERFACE/widgets/roundbutton.dart';
import 'package:firebase_tutorials/utils/utils.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Forgot Password Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailcontroller,
                decoration: InputDecoration(helperText: 'Enter e_mail'),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            RoundButton(
                title: 'Forgot',
                ontap: () {
                  auth
                      .sendPasswordResetEmail(
                          email: emailcontroller.text.toString())
                      .then((value) => Utils.flushBarErrorMessage(
                          'We have sent you a e_mail to recover your password, Kindly check your email',
                          context))
                      .catchError((error) {
                    // Handle the error using the provided 'error' parameter

                    Utils.flushBarErrorMessage(error.toString(), context);
                    // setState(() {
                    //   loading = false;
                    // });
                  });
                })
          ],
        ),
      ),
    );
  }
}
