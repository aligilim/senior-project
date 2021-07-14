import 'package:covid_app/widgets/patients_analyze_widget.dart';
import 'package:covid_app/widgets/symptoms_analyze_widget.dart';
import 'package:flutter/material.dart';

class AnalyzePatientDataScreen extends StatelessWidget {
  static const routeName = 'analyze-screen';
  AnalyzePatientDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analyze Patient Data'),
      ),
      body: ListView(
        children: [
          SymptomsAnalyzeWidget(),
          PatientAnalyzeWidget(),
        ],
      ),
    );
  }
}
