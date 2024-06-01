import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/USER_INTERFACE/auth/posts/post_screen.dart';
import 'package:firebase_tutorials/USER_INTERFACE/widgets/roundbutton.dart';
import 'package:firebase_tutorials/utils/utils.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  @override
  bool loading = false;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance; // initilazing the firebase in this screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Verification'),
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
              controller: verificationCodeController,
              decoration: InputDecoration(hintText: '6 digits code'),
            ),
            SizedBox(
              height: 80,
            ),
            RoundButton(
                title: 'Verify',
                loading: loading,
                ontap: () async {
                  setState(() {
                    loading = true;
                  });
                  final Credential = PhoneAuthProvider.credential(
                      // this code is for signup after the verification code
                      verificationId: widget.verificationId,
                      smsCode: verificationCodeController.text.toString());
                  try {
                    await auth.signInWithCredential(Credential);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostScreen()));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils.flushBarErrorMessage(e.toString(), context);
                  }
                })
          ],
        ),
      ),
    );
  }
}
