import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  FirebaseFirestore? firebaseFirestore;
  CollectionReference? noteRef;
  @override
  void initState() {
    super.initState();
    firebaseFirestore = FirebaseFirestore.instance;
    noteRef = firebaseFirestore!.collection("notes");
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        showModalBottomSheet(context: context, builder: (_){
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Add Note"),
                SizedBox(
                  height: 11,
                ),
                TextField(
                  controller: titleController,
                ),
                SizedBox(
                  height: 11,
                ),
                TextField(
                  controller: descController,
                ),
                SizedBox(
                  height: 11,
                ),
                Row(
                  children: [
                    OutlinedButton(onPressed: () async{
                      /*DocumentReference newDoc = await noteRef!.add({
                        "title" : "New Note",
                        "desc" : "New Note Description",
                        "created_at" : "${DateTime.now().millisecondsSinceEpoch}"
                      });*/

                      await noteRef!.doc('${DateTime.now().millisecondsSinceEpoch}').set({
                        "title" : titleController.text,
                        "desc" : descController.text,
                        "created_at" : "${DateTime.now().millisecondsSinceEpoch}"
                      });
                      Navigator.pop(context);
                    }, child: Text('Add')),
                    SizedBox(
                      width: 11,
                    ),
                    OutlinedButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text('Cancel'))
                  ],
                )
              ],
            ),
          );
        });
      }, child: Icon(Icons.add),),
    );
  }
}
