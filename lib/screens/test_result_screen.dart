import 'package:covid_app/providers/auth.dart';
import 'package:covid_app/providers/operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/extensions.dart';

class TestResultScreen extends StatefulWidget {
  static const routeName = 'test-result-screen';
  const TestResultScreen({Key? key}) : super(key: key);

  @override
  _TestResultScreenState createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Operation>(context, listen: false)
          .getTestResult(Provider.of<Auth>(context, listen: false).user!.id!)
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
    final testResults = Provider.of<Operation>(context).testResults;
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Results'),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : testResults.length <= 0
              ? Center(
                  child: Text('No Results to show'),
                )
              : ListView(
                  shrinkWrap: true,
                  children: testResults
                      .map(
                        (test) => Column(
                          children: [
                            ListTile(
                              title: Text(test.patientName.capitalize()),
                              subtitle: Text(test.date),
                              trailing: test.positive
                                  ? CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Text('+ve'),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: Text('-ve'),
                                    ),
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
