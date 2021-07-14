import 'package:covid_app/widgets/ages_line_chart_widget.dart';
import 'package:covid_app/widgets/symptoms_day_chart_widget.dart';
import 'package:covid_app/providers/operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientAnalyzeWidget extends StatefulWidget {
  PatientAnalyzeWidget({Key? key}) : super(key: key);

  @override
  _SymptomsAnalyzeWidgetState createState() => _SymptomsAnalyzeWidgetState();
}

class _SymptomsAnalyzeWidgetState extends State<PatientAnalyzeWidget> {
  bool isInit = true;
  int sqltime = 0;
  int fbtime = 0;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Stopwatch sqlcount = Stopwatch()..start();
      Provider.of<Operation>(context, listen: false)
          .getSQLPatients()
          .then((value) {
        sqltime = sqlcount.elapsed.inMilliseconds;
        print('getSQLSymptoms() executed in $sqltime');
        sqlcount..stop();
        Stopwatch fbcount = Stopwatch()..start();
        Provider.of<Operation>(context, listen: false)
            .getPatients()
            .then((value) {
          fbtime = fbcount.elapsed.inMilliseconds;
          print('getAllSymptoms() executed in $sqltime');
          fbcount..stop();
          setState(() {
            isInit = false;
          });
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('SQL Patients Data'),
          subtitle: Text('Execution Time $sqltime Milliseconds'),
        ),
        ListTile(
          title: Text('Firebase Patients Data'),
          subtitle: Text('Execution Time $fbtime Milliseconds'),
        ),
        AgesLineChartWidget(),
      ],
    );
  }
}
