import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_in_flutter/pages/status.dart';

class GetSamashya extends StatelessWidget {
  final String documentId;
  const GetSamashya({super.key, required this.documentId});

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
                    builder: (context) => Status(
                      documentId: documentId,
                      problemProcess: data['problemProcess'],
                    ),
                  ),
                );
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