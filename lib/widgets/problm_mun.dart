// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import 'get_samashya.dart';

class ProblmMun extends StatefulWidget {
  static const String _title = 'Status about complain';

  @override
  State<ProblmMun> createState() => _ProblmMunState();
}

class _ProblmMunState extends State<ProblmMun> {
  // final List<Complain> allComplain;
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
        .where("problemProcess", isNotEqualTo: "completed")
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

  Future<void> refreshProblems() async {
    List<String> documentIds = [];
    await FirebaseFirestore.instance
        .collection('problems')
        // .where("higherAuthority", isEqualTo: false)
        .where(
          "problemProcess",
          isNotEqualTo: "completed",
        )
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
                child: CircularProgressIndicator(),
              );
            }
          case ConnectionState.done:
            {
              return RefreshIndicator(
                onRefresh: refreshProblems,
                child: ListView.builder(
                  itemCount: _docIds.length,
                  prototypeItem: ListTile(
                    title: Text("Document Ids"),
                  ),

                  // To make listView scrollable
                  // even if there is only a single item.
                  physics: const AlwaysScrollableScrollPhysics(),

                  itemBuilder: (context, index) {
                    return GetSamashya(
                      documentId: _docIds[index],
                      refreshProblems: refreshProblems,
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
