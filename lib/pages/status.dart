import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Statusbar extends StatefulWidget {
  final String documentId;
  final String problemProcess;
  final String title = "Stepper Demo";
  final Function refreshProblems;

  const Statusbar(
      {super.key,
      required this.documentId,
      required this.problemProcess,
      required this.refreshProblems});
  @override
  State<Statusbar> createState() {
    return _StatusState();
  }
}

class _StatusState extends State<Statusbar> {
  // final String documentId;
  // final String problemProcess;
  //
  int current_step = 1;

  List<Step> steps = [
    Step(
      title: Text('Register Complain'),
      // content: Text('User Registerd Complain'),
      content: Text('Please Confirmed Person complain'),
      state: StepState.complete,
      isActive: true,
    ),
    Step(
      title: Text('Complain Confirmed'),
      content: Text('Please start the process'),
      isActive: true,
    ),
    Step(
      title: Text('Complain Processed'),
      content: Text('Continue if Complain is Solved'),
      isActive: true,
    ),
    Step(
      title: Text('Complain Solved'),
      content: Text('finally you completed'),
      state: StepState.complete,
      isActive: true,
    ),
    // Step(
    //   title: Text('Complain Solved'),
    //   content: Text('finally you completed'),
    //   state: StepState.complete,
    //   isActive: false,
    // ),
    // Step(
    //   title: Text('Step 5'),
    //   content: Text('Hello World!'),
    //   state: StepState.complete,
    //   isActive: true,
    // ),
  ];

  // _StatusState({required this.documentId, required this.problemProcess});
  @override
  Widget build(BuildContext context) {
    if (widget.problemProcess == "register") {
      current_step = 0;
    } else if (widget.problemProcess == "confirmed") {
      current_step = 1;
    } else if (widget.problemProcess == "processed") {
      current_step = 2;
    } else if (widget.problemProcess == "completed") {
      current_step = 3;
    }
    //get the collection
    CollectionReference problem =
        FirebaseFirestore.instance.collection('problems');
    //  else if (problemProcess == "solved") {
    //    current_step = 1;
    // }
    return Scaffold(
      // Appbar
      appBar: AppBar(
        // Title
        title: Text("Simple Stepper Demo"),
      ),
      // Body
      body: Container(
        child: current_step < 3
            ? Stepper(
                currentStep: this.current_step,
                steps: steps,
                type: StepperType.vertical,
                onStepTapped: (step) {
                  setState(() {
                    current_step = step;
                  });
                },
                onStepContinue: () {
                  print("yessssss ${current_step}");
                  if (current_step < steps.length - 1) {
                    if (current_step + 1 == 1) {
                      //update collection
                      problem.doc(widget.documentId).update(
                        {"problemProcess": "confirmed"},
                      );
                      // widget.problemProcess= "confirmed",
                    } else if (current_step + 1 == 2) {
                      //update collection
                      problem.doc(widget.documentId).update(
                        {"problemProcess": "processed"},
                      );
                      // widget.problemProcess= "confirmed",
                    } else if (current_step + 1 == 3) {
                      //update collection
                      problem.doc(widget.documentId).update(
                        {"problemProcess": "completed"},
                      );
                    }
                    setState(() {
                      current_step += 1;
                    });
                  } else {
                    current_step == 3;
                    //update collection
                    problem.doc(widget.documentId).update(
                      {"problemProcess": "completed"},
                    );
                  }
                  //  else if (current_step == 4) {
                  //   current_step = 3;
                  // }
                  print("yessssss ${current_step}");
                  widget.refreshProblems;
                  Navigator.pop(context);
                },
                onStepCancel: () {
                  print("yessssss ${current_step}");
                  if (current_step > 1) {
                    if (current_step - 1 == 1) {
                      //update collection
                      problem.doc(widget.documentId).update(
                        {"problemProcess": "confirmed"},
                      );
                    } else if (current_step - 1 == 2) {
                      //update collection
                      problem.doc(widget.documentId).update(
                        {"problemProcess": "processed"},
                      );
                      // } else if (current_step - 1 == 3) {
                      //   //update collection
                      //   problem.doc(widget.documentId).update(
                      //     {"problemProcess": "completed"},
                      //   );
                    }
                    setState(() {
                      current_step -= 1;
                    });
                  } else {
                    current_step = 1;
                    //update collection
                    problem.doc(widget.documentId).update(
                      {"problemProcess": "register"},
                    );
                  }
                  print("yessssss ${current_step}");
                  widget.refreshProblems;
                  Navigator.pop(context);
                },
              )
            : Center(
                child: Text("Completed"),
              ),
      ),
    );
  }
}

// /////////////////////////////////////////////////////////////////////////////
///////////////////
////////////////////////////////////////////////////////////////////////////////
/* 
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Statusbar extends StatefulWidget {
  final String? problemProcess;
  final String documentId;
  const Statusbar({
    Key? key,
    required this.problemProcess,
    required this.documentId,
  }) : super(key: key);

  @override
  State<Statusbar> createState() => _StatusbarState();
}

class _StatusbarState extends State<Statusbar> {
  // Step Counter
  int current_step = 0;

  // List<Step> examples = [
  //   Step(
  //     title: Text('Step 1'),
  //     content: Text('Hello!'),
  //     isActive: true,
  //   ),
  //   Step(
  //     title: Text('Step 2'),
  //     content: Text('World!'),
  //     isActive: true,
  //   ),
  //   Step(
  //     title: Text('Step 3'),
  //     content: Text('Hello World!'),
  //     state: StepState.complete,
  //     isActive: true,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    IndicatorStyle indiCompleted = IndicatorStyle(
      width: 25,
      indicatorXY: .5,
      // padding: EdgeInsets.all(8.0),
      color: Theme.of(context).primaryColor,
      iconStyle: IconStyle(
        fontSize: 17,
        color: Colors.white,
        iconData: Icons.check,
      ),
    );
    IndicatorStyle indiProcess = IndicatorStyle(
      width: 25,
      indicatorXY: .5,
      // padding: EdgeInsets.all(8.0),
      color: Theme.of(context).primaryColor,
      iconStyle: IconStyle(
        fontSize: 17,
        color: Colors.white,
        iconData: Icons.loop_rounded,
      ),
    );
    // IndicatorStyle indiNotComplete = IndicatorStyle(
    //   width: 20,
    //   indicatorXY: .5,
    //   padding: EdgeInsets.all(8.0),
    //   color: Theme.of(context).primaryColor,
    //   iconStyle: IconStyle(
    //     fontSize: 15,
    //     color: Colors.white,
    //     iconData: Icons.loop_rounded,
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Problem Status"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: .1,
            isFirst: true,
            afterLineStyle: LineStyle(color: Theme.of(context).primaryColor),
            indicatorStyle: indiCompleted,
            endChild: Container(
              child: Column(
                children: [
                  Text(
                    "Register Complain",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("continue"),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("cancle"),
                      ),
                    ],
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: .1,
            afterLineStyle: LineStyle(
              color: Theme.of(context).primaryColor,
            ),
            beforeLineStyle: LineStyle(
              color: Theme.of(context).primaryColor,
            ),
            indicatorStyle: indiCompleted,
            endChild: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Complain Confirmed",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("continue"),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("cancle"),
                      ),
                    ],
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: .1,
            afterLineStyle: LineStyle(
              color: Theme.of(context).primaryColor,
            ),
            beforeLineStyle: LineStyle(
              color: Theme.of(context).primaryColor,
            ),
            indicatorStyle: indiProcess,
            endChild: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Complain Processed",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: .1,
            hasIndicator: false,
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: .1,
            isLast: true,
            endChild: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Text(
                    "Complain Solved",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("continue"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("cancle"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // Container(
    //   decoration: const BoxDecoration(
    //     gradient: LinearGradient(
    //       begin: Alignment.topLeft,
    //       end: Alignment.bottomRight,
    //       colors: [
    //         Color(0xFF004E92),
    //         Color(0xFF000428),
    //       ],
    //     ),
    //   ),
    //   child: SafeArea(
    //     child:
    //   ),
    // );
  }
}

// class _IndicatorExample extends StatelessWidget {
//   const _IndicatorExample({Key? key, required this.number}) : super(key: key);

//   final String number;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.fromBorderSide(
//           BorderSide(
//             color: Colors.white.withOpacity(0.2),
//             width: 4,
//           ),
//         ),
//       ),
//       child: Center(
//         child: Text(
//           number,
//           style: const TextStyle(fontSize: 30),
//         ),
//       ),
//     );
//   }
// }

// class _RowExample extends StatelessWidget {
//   const _RowExample({Key? key, required this.example}) : super(key: key);

//   final Example example;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: Text(
//               example.name,
//               style: GoogleFonts.jura(
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//             ),
//           ),
//           const Icon(
//             Icons.navigate_next,
//             color: Colors.white,
//             size: 26,
//           ),
//         ],
//       ),
//     );
//   }
// }
 */