import 'package:firebase_tutorials/USER_INTERFACE/auth/login_screen.dart';
import 'package:firebase_tutorials/USER_INTERFACE/widgets/roundbutton.dart';
import 'package:firebase_tutorials/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance; // initilazing the firebase.
  @override
  void dispose() {
    // TODO: implement dispose              // dispose function is used for when screen will change it will release e_mail and password from memory

    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(
            child: Text(
          'SignUp',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        hintText: 'e-mail',
                        helperText: 'enter e-mail e.g mehar@gmail.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter e-mail';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: passwordcontroller,
                      obscureText: true, // for password hide
                      decoration: InputDecoration(
                        hintText: 'password',
                        helperText: 'enter your passowrd',
                        prefixIcon: Icon(Icons.password),
                      ),

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                      },
                    ),
                  ],
                )),
            SizedBox(
              height: 50,
            ),
            RoundButton(
              title: 'signup',
              loading: loading,
              ontap: () {
                if (_formkey.currentState!.validate()) {
                  setState(() {
                    loading = true; //loading
                  });

                  _auth
                      .createUserWithEmailAndPassword(
                          email: emailcontroller.text.toString(),
                          password: passwordcontroller.text.toString())
                      .then((value) => {
                            setState(() {
                              loading = false;

                              /// lodiang
                            })
                            // Handle successful login if needed
                          })
                      .catchError((error) {
                    Utils.flushBarErrorMessage(error.toString(), context);
                    setState(() {
                      loading = false; //loading
                    });
                  });
                }
              }, // if statement is for that e_mail and pasword is filled or not
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text('Log In'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
