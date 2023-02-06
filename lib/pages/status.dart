import 'package:flutter/material.dart';

class Status extends StatefulWidget {
  final String documentId;
  final String problemProcess;
  final String title = "Stepper Demo";

  const Status(
      {super.key, required this.documentId, required this.problemProcess});
  @override
  State<Status> createState() => _StatusState(
        documentId: documentId,
        problemProcess: problemProcess,
      );
}

class _StatusState extends State<Status> {
  final String documentId;
  final String problemProcess;
  //
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

  _StatusState({required this.documentId, required this.problemProcess});
  @override
  Widget build(BuildContext context) {
    if (problemProcess == "register") {
      current_step = 1;
    } else if (problemProcess == "confirmed") {
      current_step = 2;
    } else if (problemProcess == "processed") {
      current_step = 3;
    }
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
        child: Stepper(
          currentStep: this.current_step,
          steps: steps,
          type: StepperType.vertical,
          onStepTapped: (step) {
            setState(() {
              current_step = step;
            });
          },
          onStepContinue: () {
            setState(() {
              if (current_step < steps.length - 1) {
                current_step = current_step + 1;
              } else {
                current_step = 3;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (current_step > 1) {
                current_step = current_step - 1;
              } else {
                current_step = 1;
              }
            });
          },
        ),
      ),
    );
  }
}
