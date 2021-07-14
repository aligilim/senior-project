import 'package:covid_app/providers/operation.dart';
import 'package:covid_app/screens/patient_medical_reports_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../helpers/extensions.dart';

class AddMedicalReportScreen extends StatefulWidget {
  static const routeName = 'add-medical-report-screen';
  const AddMedicalReportScreen({Key? key}) : super(key: key);

  @override
  _AddMedicalReportScreenState createState() => _AddMedicalReportScreenState();
}

class _AddMedicalReportScreenState extends State<AddMedicalReportScreen> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Operation>(context, listen: false)
          .getPatients()
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
    final patients = Provider.of<Operation>(context).patients;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medical Report'),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : patients.length <= 0
              ? Center(
                  child: Text('No Patients to show'),
                )
              : ListView(
                  children: patients
                      .map(
                        (patient) => Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        PatientMedicalReportsScreen(
                                      patient: patient,
                                    ),
                                  ),
                                );
                              },
                              title: Text(patient.name.capitalize()),
                              subtitle: Text(patient.email ?? 'UNKNOWN'),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                            Divider(),
                          ],
                        ),
                      )
                      .toList(),
                ),
    );
  }
}
