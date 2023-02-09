// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_in_flutter/pages/status.dart';

class GetSamashya extends StatelessWidget {
  final String documentId;
  final Function refreshProblems;
  const GetSamashya({
    Key? key,
    required this.documentId,
    required this.refreshProblems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference problem =
        FirebaseFirestore.instance.collection('problems');

    return FutureBuilder(
      future: problem.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ListTile(
            title: Text("${data['problem']}"),
            subtitle: Text("${data['address']}"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Statusbar(
                      documentId: documentId,
                      problemProcess: data['problemProcess'],
                      refreshProblems: refreshProblems,
                    ),
                  ),
                );
                refreshProblems;
              },
            ),

            isThreeLine: true,
            // isThreeLine: true,
          );
        }
        return ListTile(
          title: Text("waiting..."),
        );
      },
    );
  }
}
