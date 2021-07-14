import 'package:covid_app/models/test_result.dart';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/providers/operation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../helpers/extensions.dart';

class AddTestResultScreen extends StatefulWidget {
  static const routeName = 'add-test-result-screen';
  const AddTestResultScreen({Key? key}) : super(key: key);

  @override
  _AddTestResultScreenState createState() => _AddTestResultScreenState();
}

class _AddTestResultScreenState extends State<AddTestResultScreen> {
  bool isInit = true;
  bool _isPositive = true;
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
        title: Text('Patients'),
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
                                _addTestResult(patient);
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

  Future<void> _addTestResult(UserData patient) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        String date = DateFormat.yMMMd().add_jm().format(DateTime.now());
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              "Add Test Result",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text('Test Result Date'),
                  trailing: Text(date),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text('is a Positive result?'),
                  value: _isPositive,
                  onChanged: (value) {
                    setState(() {
                      _isPositive = !_isPositive;
                      print('$_isPositive');
                    });
                  },
                ),
              ],
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.green[900],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Provider.of<Operation>(context, listen: false).addTestResult(
                      TestResult(
                        date: date,
                        patientName: patient.name!,
                        patientEmail: patient.email!,
                        positive: _isPositive,
                      ),
                      patient.id!);
                },
              ),
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.green[900],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
