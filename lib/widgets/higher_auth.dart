import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_in_flutter/pages/status.dart';
import 'package:skeletons/skeletons.dart';

// import '../pages/status.dart';

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
        .where("higherAuthority", isEqualTo: true)
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
        .where("higherAuthority", isEqualTo: true)
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
              // return Skeleton(
              //   isLoading: true,
              //   skeleton: SkeletonListView(),
              //   child: Container(child: Center(child: Text("Content"))),
              // );
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
                    return getSamashya(
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

Widget getSamashya(
    {required String documentId, required Function refreshProblems}) {
  int current_step = 1;

  List<Step> steps = [
    Step(
      title: Text('Register Complain'),
      content: Text('User Registerd Complain'),
      isActive: true,
    ),
    Step(
      title: Text('Complain Confirmed'),
      content: Text('Please Confirmed Person complain'),
      isActive: true,
    ),
    Step(
      title: Text('Complain Processed'),
      content: Text(''),
      isActive: true,
    ),
    Step(
      title: Text('Complain Solved'),
      content: Text('finally you completed'),
      state: StepState.complete,
      isActive: true,
    ),
    // Step(
    //   title: Text('Step 5'),
    //   content: Text('Hello World!'),
    //   state: StepState.complete,
    //   isActive: true,
    // ),
  ];

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
                builder: (context) => Statusbar(
                  documentId: documentId,
                  problemProcess: data['problemProcess'],
                  refreshProblems: refreshProblems,
                  // problemProcess: data['problemProcess'],
                ),
              ),
            ),
            refreshProblems,
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

// class Status extends StatefulWidget {
//   final String documentId;
//   final String problemProcess;
//   final String title = "Stepper Demo";

//   const Status(
//       {super.key, required this.documentId, required this.problemProcess});
//   @override
//   State<Status> createState() {
//     return _StatusState(
//         // documentId: documentId,
//         // problemProcess: problemProcess,
//         );
//   }
// }

// class _StatusState extends State<Status> {
//   // final String documentId;
//   // final String problemProcess;
//   //
//   int current_step = 1;

//   List<Step> steps = [
//     Step(
//       title: Text('Register Complain'),
//       content: Text('User Registerd Complain'),
//       isActive: true,
//     ),
//     Step(
//       title: Text('Complain Confirmed'),
//       content: Text('Please Confirmed Person complain'),
//       isActive: true,
//     ),
//     Step(
//       title: Text('Complain Processed'),
//       content: Text(''),
//       isActive: true,
//     ),
//     Step(
//       title: Text('Complain Solved'),
//       content: Text('finally you completed'),
//       state: StepState.complete,
//       isActive: true,
//     ),
//     // Step(
//     //   title: Text('Step 5'),
//     //   content: Text('Hello World!'),
//     //   state: StepState.complete,
//     //   isActive: true,
//     // ),
//   ];

//   // _StatusState({required this.documentId, required this.problemProcess});
//   @override
//   Widget build(BuildContext context) {
//     if (widget.problemProcess == "register") {
//       current_step = 1;
//     } else if (widget.problemProcess == "confirmed") {
//       current_step = 2;
//     } else if (widget.problemProcess == "processed") {
//       current_step = 3;
//     }
//     //get the collection
//     CollectionReference problem =
//         FirebaseFirestore.instance.collection('problems');
//     //  else if (problemProcess == "solved") {
//     //    current_step = 1;
//     // }
//     return Container(
//       child: Stepper(
//         currentStep: this.current_step,
//         steps: steps,
//         type: StepperType.vertical,
//         onStepTapped: (step) {
//           setState(() {
//             current_step = step;
//           });
//         },
//         onStepContinue: () {
//           if (current_step < steps.length - 1) {
//             if (current_step + 1 == 2) {
//               //update collection
//               problem.doc(widget.documentId).update(
//                 {"problemProcess": "confirmed"},
//               );
//               // widget.problemProcess= "confirmed",
//             } else if (current_step + 1 == 3) {
//               //update collection
//               problem.doc(widget.documentId).update(
//                 {"problemProcess": "processed"},
//               );
//             }
//             setState(() {
//               current_step += 1;
//             });
//           } else {
//             //update collection
//             problem.doc(widget.documentId).update(
//               {"problemProcess": "completed"},
//             );
//           }
//           //  else if (current_step == 4) {
//           //   current_step = 3;
//           // }
//         },
//         onStepCancel: () {
//           setState(() {
//             if (current_step > 1) {
//               current_step = current_step - 1;
//               if (current_step == 2) {
//                 //update collection
//                 problem.doc(widget.documentId).update(
//                   {"problemProcess": "confirmed"},
//                 );
//               } else if (current_step == 3) {
//                 //update collection
//                 problem.doc(widget.documentId).update(
//                   {"problemProcess": "processed"},
//                 );
//               }
//             } else {
//               //update collection
//               problem.doc(widget.documentId).update(
//                 {"problemProcess": "register"},
//               );
//             }
//           });
//         },
//       ),
//     );
//   }
// }
