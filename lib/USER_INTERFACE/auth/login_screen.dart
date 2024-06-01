import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_tutorials/USER_INTERFACE/auth/login_with_phone.dart';
import 'package:firebase_tutorials/USER_INTERFACE/auth/posts/post_screen.dart';
import 'package:firebase_tutorials/USER_INTERFACE/auth/signup_screen.dart';
import 'package:firebase_tutorials/USER_INTERFACE/forgot_password.dart';
import 'package:firebase_tutorials/USER_INTERFACE/widgets/roundbutton.dart';
import 'package:firebase_tutorials/utils/utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    // super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailcontroller.text,
            password: passwordcontroller.text.toString())
        .then((value) {
      Utils.flushBarErrorMessage(value.user!.email.toString(), context);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PostScreen()));
      setState(() {
        loading = false;
      });
      // Handle successful login if needed
    }).catchError((error) {
      // Handle the error using the provided 'error' parameter
      debugPrint(error.toString());
      Utils.flushBarErrorMessage(error.toString(), context);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(
            child: Text(
          'Login',
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
              height: 20,
            ),
            RoundButton(
              title: 'login',
              loading: loading,
              ontap: () {
                if (_formkey.currentState!.validate()) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    login();
                  });
                  //login();
                }
              }, // if statement is for that e_mail and pasword is filled or not
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text('Dont have an account?'),
                  TextButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                      },
                      child: Text('Forgot Password?')),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Dont have an account?'),
                TextButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                    child: Text('Sign Up')),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginWithPhoneNumber()));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black)),
                child: Center(child: Text('Login with phone')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
