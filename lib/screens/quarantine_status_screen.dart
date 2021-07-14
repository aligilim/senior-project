import 'package:covid_app/models/user.dart';
import 'package:covid_app/providers/operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/extensions.dart';

class QuarantineStatusScreen extends StatefulWidget {
  static const routeName = 'quarantine-status-screen';
  const QuarantineStatusScreen({Key? key}) : super(key: key);

  @override
  _QuarantineStatusScreenState createState() => _QuarantineStatusScreenState();
}

class _QuarantineStatusScreenState extends State<QuarantineStatusScreen> {
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
        title: Text('Quarantine Status Screen'),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : patients.length <= 0
              ? Center(
                  child: Text('No Patient to show'),
                )
              : ListView(
                  padding: EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
                  children: patients
                      .map(
                        (patient) => Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => PatientStatusScreen(
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

class PatientStatusScreen extends StatefulWidget {
  final UserData patient;
  PatientStatusScreen({Key? key, required this.patient}) : super(key: key);

  @override
  _PatientStatusScreenState createState() => _PatientStatusScreenState();
}

class _PatientStatusScreenState extends State<PatientStatusScreen> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Operation>(context, listen: false)
          .getQuarantineData(widget.patient.id!)
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
    final quarantineData = Provider.of<Operation>(context).quarantineData;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.name!),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : quarantineData.length <= 0
              ? Center(
                  child: Text('No Data to show'),
                )
              : ListView(
                  children: quarantineData
                      .map(
                        (item) => Column(
                          children: [
                            ListTile(
                              subtitle: Text(item.date),
                              trailing: Icon(
                                item.isHome ? Icons.check : Icons.close,
                                color: item.isHome ? Colors.green : Colors.red,
                                size: 30,
                              ),
                              title:
                                  Text(item.isHome ? 'At Home' : 'Not At Home'),
                            ),
                            Divider(
                              height: 0.0,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
    );
  }
}
