import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CatPage extends StatefulWidget {
  @override
  State<CatPage> createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> {
  FirebaseFirestore? firebaseFirestore;

  CollectionReference? catRef;

  @override
  void initState() {
    super.initState();
    firebaseFirestore = FirebaseFirestore.instance;
    catRef = firebaseFirestore!
        .collection("category");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),

      body: catRef != null
          ? StreamBuilder<QuerySnapshot>(
        stream: catRef!.snapshots(),
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
                snap.data!.docs[index].data()
                as Map<String, dynamic>;
                return ListTile(
                  leading: Image.network(data["imgUrl"]),
                  title: Text(data["name"]),
                  //subtitle: Text(data["price"].toString()),
                );
              },
            )
                : Center(child: Text('No Data Found'));
          }

          return Container();
        },
      )
          : Center(child: CircularProgressIndicator()),

    );
  }
}
