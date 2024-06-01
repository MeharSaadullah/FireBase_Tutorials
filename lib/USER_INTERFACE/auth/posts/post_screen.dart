//import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorials/USER_INTERFACE/Image_upload.dart';
import 'package:firebase_tutorials/USER_INTERFACE/auth/login_screen.dart';
import 'package:firebase_tutorials/USER_INTERFACE/auth/posts/add_posts.dart';
import 'package:firebase_tutorials/USER_INTERFACE/widgets/roundbutton.dart';
import 'package:firebase_tutorials/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth
      .instance; // for log out.....initilize firebase in this function

  final ref = FirebaseDatabase.instance
      .ref('Post'); // for fetching data from firebase ,  post is name of column

  final searchfilter = TextEditingController(); // serachbar code

  final editcontroller =
      TextEditingController(); // thsi controller is updae of data

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
          child: Text('Posts'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              // creating searchbar

              controller: searchfilter, // use search controlller here
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                ),
                hintText: 'Search',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              ),
              onChanged: (String value) {
                // this code also use for search when user keyword value will changed
                setState(() {});
              },
            ),
          ),
          // Expanded(                    //2nd methood code for which data was fetched from fire base
          //     child: StreamBuilder(
          //   stream: ref.onValue,
          //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //     if (!snapshot.hasData) {
          //       return CircularProgressIndicator();
          //     } else {
          //       Map<dynamic, dynamic> map =
          //           snapshot.data!.snapshot.value as dynamic;
          //       List<dynamic> list = [];
          //       list.clear();
          //       list = map.values.toList();

          //       return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(list[index]['title']),
          //               subtitle: Text(list[index]['id']),
          //             );
          //           });
          //     }
          //   },
          // )),
          Expanded(
            //1st methood code for which data was fetched from fire base
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: Text('Loading'),
                itemBuilder: (context, snapshot, animation, builder) {
                  final title = snapshot.child('title').value.toString();
                  if (searchfilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(
                        snapshot.child('id').value.toString(),
                        style: TextStyle(color: Colors.amber),
                      ),
                      trailing: PopupMenuButton(
                          //this code is for frnot end of updation,deletion etc
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showMyDialog(
                                      title,
                                      snapshot.child('id').value.toString(),
                                    ); // we call that function here
                                  },
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                )),
                                PopupMenuItem(
                                    child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    ref
                                        .child(
                                          snapshot.child('id').value.toString(),
                                        )
                                        .remove();
                                  },
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                )),
                              ]),
                    );
                  } else if (title // main part of search is that code
                      .toLowerCase()
                      .contains(searchfilter.text.toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(
                        snapshot.child('id').value.toString(),
                        style: TextStyle(color: Colors.amber),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),

          RoundButton(
            title: 'Want to upload Image',
            ontap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageUploadScreen()),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
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
                    ref // main part of code for data updation
                        .child(id)
                        .update({'title': editcontroller.text.toString()}).then(
                            (value) => Utils.flushBarErrorMessage(
                                'Data Update', context))
                      ..catchError((error) {
                        Utils.flushBarErrorMessage(error.toString(), context);
                      });
                  },
                  child: Text('Update')),
            ],
          );
        });
  }
}
