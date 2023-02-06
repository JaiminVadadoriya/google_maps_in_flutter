// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'get_samashya.dart';

class ProblmMun extends StatelessWidget {
  static const String _title = 'Status about complain';
  // final List<Complain> allComplain;
  // UserHome({
  //   Key? key,
  //   required this.allComplain,
  // }) : super(key: key);

// documents ids
  List<String> docIds = [];

  Future samashyaHe() async {
//get the collection
    await FirebaseFirestore.instance.collection('problems').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              docIds.add(document.reference.id);
            },
          ),
        );
    // CollectionReference samashaya =
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: samashyaHe(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: docIds.length,
            prototypeItem: ListTile(
              title: Text("Document Ids"),
            ),
            itemBuilder: (context, index) {
              return GetSamashya(
                documentId: docIds[index],
              );
            },
          );
        },
      ),
    );
  }
}
