import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../pages/status.dart';

class HigherAuth extends StatefulWidget {
  @override
  State<HigherAuth> createState() => _HigherAuthState();
}

class _HigherAuthState extends State<HigherAuth> {
// documents ids
  List<String> _docIds = [];

  // List<Complain> complain = [];
  late Future<void> _initProblemsData;

  @override
  void initState() {
    super.initState();
    _initProblemsData = _initProblems();
  }

  Future<void> _initProblems() async {
    List<String> documentIds = [];
    await FirebaseFirestore.instance
        .collection('problems')
        .where("higherAuthority", isEqualTo: false)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              documentIds.add(document.reference.id);
            },
          ),
        );

    _docIds = documentIds;
  }

  Future<void> _refreshProblems() async {
    List<String> documentIds = [];
    await FirebaseFirestore.instance
        .collection('problems')
        .where("higherAuthority", isEqualTo: false)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              documentIds.add(document.reference.id);
            },
          ),
        );
    setState(() {
      _docIds = documentIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initProblemsData,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            {
              return Center(
                child: Text('Loading...'),
              );
            }
          case ConnectionState.done:
            {
              return RefreshIndicator(
                onRefresh: _refreshProblems,
                child: ListView.builder(
                  itemCount: _docIds.length,
                  prototypeItem: ListTile(
                    title: Text("Document Ids"),
                  ),

                  // To make listView scrollable
                  // even if there is only a single item.
                  physics: const AlwaysScrollableScrollPhysics(),

                  itemBuilder: (context, index) {
                    return getSamashya(
                      documentId: _docIds[index],
                    );
                    // return ListTile(
                    //   title: Text(docIds[index]),
                    //   trailing: Icon(Icons.edit),
                    //   // isThreeLine: true,
                    // ),
                  },
                  // );
                  // },

                  //     child: ListView.builder(
                  //   itemCount: allComplain.length,
                  //   prototypeItem: ListTile(
                  //     title: Text(allComplain[0].problem! + ""),
                  //     subtitle: Text(allComplain[0].address!),
                  //     trailing: Icon(Icons.edit),
                  //     isThreeLine: true,
                  //   ),
                  //   itemBuilder: (context, index) {
                  //     return ListTile(
                  //       title: Text(allComplain[index].problem!),
                  //       subtitle: Text(
                  //           "${allComplain[index].address}-${allComplain[index].pincode}"),
                  //       trailing: Icon(Icons.edit),
                  //       isThreeLine: true,
                  //     );
                  //   },
                  // )
                  //  ListView(
                  //   children: const <Widget>[
                  //     Card(
                  //       child: ListTile(
                  //         // leading: FlutterLogo(size: 72.0),
                  //         title: Text('Street Light'),
                  //         subtitle: Text('near krish flat,Nikol gam, Amdavad - 382350'),
                  //         trailing: Icon(Icons.edit),
                  //         isThreeLine: true,
                  //       ),
                  //     ),
                  //     Card(
                  //       child: ListTile(
                  //         // leading: FlutterLogo(size: 72.0),
                  //         title: Text('Road'),
                  //         subtitle: Text(
                  //             'Vrindavan Society, Bapu Nagar, Ahmedabad  - 382160'),
                  //         trailing: Icon(Icons.edit),
                  //         isThreeLine: true,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              );
            }
        }
      },
    );
  }
}

Widget getSamashya({required String documentId}) {
  //get the collection
  CollectionReference problem =
      FirebaseFirestore.instance.collection('problems');
  return FutureBuilder(
    future: problem.doc(documentId).get(GetOptions()),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        return ListTile(
          title: Text("${data['problem']}"),
          subtitle: Text("${data['address']}"),
          // trailing: FeedBck(
          //   documentId: documentId,
          // ),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Status(
                  documentId: documentId,
                  problemProcess: data['problemProcess'],
                  // problemProcess: data['problemProcess'],
                ),
              ),
            )
          },
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
