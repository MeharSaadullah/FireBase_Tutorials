//import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tutorials/USER_INTERFACE/widgets/roundbutton.dart';
import 'package:firebase_tutorials/utils/utils.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postcontroller = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance
      .ref('Post'); // this code is for creation of table

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text('Add Posts')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postcontroller,
              decoration: InputDecoration(
                  hintText: "What's in your mind   ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                loading: loading,
                title: 'Add',
                ontap: () {
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef // this code is for adding data in database
                      .child(id)
                      .set({'title': postcontroller.text.toString(), 'id': id})
                      .then((value) => {
                            Utils.flushBarErrorMessage(
                                'Post Added in Database', context),
                            setState(() {
                              loading = false;
                            })
                          })
                      .catchError((error) {
                        // Handle the error using the provided 'error' parameter

                        Utils.flushBarErrorMessage(error.toString(), context);
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
