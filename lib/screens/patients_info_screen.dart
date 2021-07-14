import 'package:covid_app/providers/operation.dart';
import 'package:covid_app/widgets/ages_line_chart_widget.dart';
import 'package:covid_app/widgets/vaccine_bar_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientsInfoScreen extends StatefulWidget {
  static const routeName = 'patients-info-screen';
  PatientsInfoScreen({Key? key}) : super(key: key);

  @override
  _PatientsInfoScreenState createState() => _PatientsInfoScreenState();
}

class _PatientsInfoScreenState extends State<PatientsInfoScreen> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    // if (isInit) {
    //   Provider.of<Operation>(context, listen: false)
    //       .getPatients()
    //       .then((value) {
    //     setState(() {
    //       isInit = false;
    //       Provider.of<Operation>(context, listen: false)
    //           .insertPatientsToSQL()
    //           .then((value) => print('DONE'));
    //     });
    //   });
    // }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final patients = Provider.of<Operation>(context).patients;
    final vacPatients = patients.where((patient) => patient.vaccinated);
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients Information'),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : patients.length <= 0
              ? Center(
                  child: Text('No Data to show'),
                )
              : ListView(
                  padding: EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0),
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Number of patients:'),
                      trailing: Text('${patients.length}'),
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Number of Males patients:'),
                      trailing: Text(
                          '${patients.where((patient) => patient.gender == 'Male').length}'),
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Number of Females patients:'),
                      trailing: Text(
                          '${patients.where((patient) => patient.gender == 'Female').length}'),
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Number of vaccinated patients:'),
                      trailing: Text('${vacPatients.length}'),
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Number of fully vaccinated:'),
                      trailing: Text(
                          '${vacPatients.where((el) => el.vaccineData!.dose == 'Two').length}'),
                    ),
                    Divider(),
                    Text(
                      'Vaccines:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    VaccineBarChartWidget(),
                    Divider(),
                    Text(
                      'Ages:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    AgesLineChartWidget(),
                    Divider(),
                  ],
                ),
    );
  }
}
