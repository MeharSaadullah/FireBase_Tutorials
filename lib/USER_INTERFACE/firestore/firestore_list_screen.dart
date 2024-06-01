import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorials/USER_INTERFACE/firestore/add_firestore_data.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorials/USER_INTERFACE/auth/login_screen.dart';
import 'package:firebase_tutorials/USER_INTERFACE/auth/posts/add_posts.dart';
import 'package:firebase_tutorials/utils/utils.dart';
import 'package:flutter/material.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  @override
  final auth = FirebaseAuth
      .instance; // for log out.....initilize firebase in this function

  final editcontroller =
      TextEditingController(); // thsi controller is updae of data
  final firestore = FirebaseFirestore.instance.collection('user').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection(
      'user'); // add this for deletion and updation bcz on line 27 their is snapshot instead of collection

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(
          child: Text('Firestore'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth
                  .signOut()
                  .then((value) => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()))
                      })
                  .catchError((error) {
                Utils.flushBarErrorMessage(error.toString(), context);
              });
            },
            icon: Icon(Icons.logout),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          // Here we use stream builder to fetch data and show on front
          StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Some Error');
                }

                return Expanded(
                    //1st methood code for which data was fetched from fire base
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              ref
                                  .doc(snapshot.data!.docs[index]['id']
                                      .toString()) // this code is for updation from code not from mobile
                                  .update({'title': '154'})
                                  .then((value) => Utils.flushBarErrorMessage(
                                      'update successfuly', context))
                                  .catchError((error) {
                                    Utils.flushBarErrorMessage(
                                        error.toString(), context);
                                  });
                              ref
                                  .doc(snapshot
                                      .data!
                                      .docs[index][
                                          'id'] // and this is for deletion from code by tapping on data on mobile
                                      .toString())
                                  .delete();
                            },
                            title: Text(
                                snapshot.data!.docs[index]['title'].toString()),
                            subtitle: Text(
                              snapshot.data!.docs[index]['id'].toString(),
                              style: TextStyle(color: Colors.amber),
                            ),
                          );
                        }));
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddFireStoreScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // this function is  for backend of updation of data we call it on line 138 of this code
  Future<void> showMyDialog(String title, String id) async {
    editcontroller.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextFormField(
                controller: editcontroller,
                decoration: InputDecoration(hintText: 'Edit'),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Update')),
            ],
          );
        });
  }
}
