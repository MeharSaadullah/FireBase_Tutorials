import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tutorials/USER_INTERFACE/widgets/roundbutton.dart';
import 'package:firebase_tutorials/utils/utils.dart';
import 'package:flutter/material.dart';

class AddFireStoreScreen extends StatefulWidget {
  const AddFireStoreScreen({super.key});

  @override
  State<AddFireStoreScreen> createState() => _AddFireStoreScreenState();
}

class _AddFireStoreScreenState extends State<AddFireStoreScreen> {
  final postcontroller = TextEditingController();
  bool loading = false;
  final firestore = FirebaseFirestore.instance
      .collection('user'); // creating  table in firestore user is name of table

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text('Add Firestore Data ')),
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
                  // line 55 onword code is for adding of data in firestore
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  firestore
                      .doc(id)
                      .set({
                        'title': postcontroller.text.toString(),
                        'id': id,
                      })
                      .then((value) => {
                            setState(() {
                              loading = false;
                            }),
                            Utils.flushBarErrorMessage(
                                'Post upload on firestore', context)
                          })
                      .catchError((error) {
                        // Handle the error using the provided 'error' parameter

                        Utils.flushBarErrorMessage(error.toString(), context);
                        setState(() {
                          loading = false;
                        });
                      });
                  ;
                })
          ],
        ),
      ),
    );
  }
}
