import 'package:covid_app/models/user.dart';
import 'package:covid_app/providers/auth.dart';
import 'package:covid_app/screens/create_medical_report_screen.dart';
import 'package:covid_app/providers/operation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientMedicalReportsScreen extends StatefulWidget {
  final UserData patient;
  PatientMedicalReportsScreen({
    Key? key,
    required this.patient,
  }) : super(key: key);

  @override
  _PatientMedicalReportsScreenState createState() =>
      _PatientMedicalReportsScreenState();
}

class _PatientMedicalReportsScreenState
    extends State<PatientMedicalReportsScreen> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Operation>(context, listen: false)
          .getMedicalReports(Provider.of<Auth>(context).user!.id!)
          .then((value) {
        setState(() {
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final reports = Provider.of<Operation>(context)
        .medicalReports
        .where((item) => item.patientId == widget.patient.id)
        .toList();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => CreateMedicalReport(
                    patient: widget.patient,
                  ),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
        title: Text('${widget.patient.name} reports'),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : reports.length <= 0
              ? Center(
                  child: Text('No Reports For This Patient'),
                )
              : ListView(
                  children: reports
                      .map(
                        (report) => Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 2.0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Diagnosis',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(report.date),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Text(report.diagnosis),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Drugs',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: report.drugs
                                      .map(
                                        (e) => ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: Text(e),
                                          leading: Icon(
                                              Icons.medical_services_outlined),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
    );
  }
}
