import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  FirebaseFirestore? firebaseFirestore;
  CollectionReference? noteRef;
  String uid = "";

  @override
  void initState() {
    super.initState();
    firebaseFirestore = FirebaseFirestore.instance;
    getUID();
  }

  getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("userId") ?? "";
    noteRef = firebaseFirestore!.collection("users").doc(uid).collection("notes");
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: noteRef != null ? StreamBuilder<QuerySnapshot>(
        stream: noteRef!.snapshots(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(child: Text("${snap.error}"));
          }

          if (snap.hasData) {
            return snap.data!.docs.isNotEmpty
                ? ListView.builder(
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (_, index) {
                      Map<String, dynamic> data =
                          snap.data!.docs[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data["title"]),
                        subtitle: Text(data["desc"]),
                      );
                    },
                  )
                : Center(child: Text('No Data Found'));
          }

          return Container();
        },
      ) : Center(child: CircularProgressIndicator(),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Add Note"),
                    SizedBox(height: 11),
                    TextField(controller: titleController),
                    SizedBox(height: 11),
                    TextField(controller: descController),
                    SizedBox(height: 11),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            /*DocumentReference newDoc = await noteRef!.add({
                        "title" : "New Note",
                        "desc" : "New Note Description",
                        "created_at" : "${DateTime.now().millisecondsSinceEpoch}"
                      });*/

                            await noteRef!
                                .doc('${DateTime.now().millisecondsSinceEpoch}')
                                .set({
                                  "title": titleController.text,
                                  "desc": descController.text,
                                  "created_at":
                                      "${DateTime.now().millisecondsSinceEpoch}",
                                });
                            Navigator.pop(context);
                          },
                          child: Text('Add'),
                        ),
                        SizedBox(width: 11),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
