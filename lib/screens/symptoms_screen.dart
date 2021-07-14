import 'package:covid_app/providers/auth.dart';
import 'package:covid_app/providers/operation.dart';
import 'package:covid_app/screens/add_symptoms_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/extensions.dart';

class SymptomsScreen extends StatefulWidget {
  static const routeName = 'symptoms-screen';
  const SymptomsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SymptomsScreenState createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  bool isInit = true;
  String _selectedDay = 'one';
  List<String> _days = [
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
  ];

  @override
  void didChangeDependencies() {
    if (isInit) {
      final userId = Provider.of<Auth>(context, listen: false).user!.id!;
      Provider.of<Operation>(context, listen: false)
          .getPatientSymptoms(userId)
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
    final deviceSize = MediaQuery.of(context).size;
    const sizedBox = const SizedBox(height: 8.0);
    final symptomsOfDay =
        Provider.of<Operation>(context).symptoms[_selectedDay];

    return Scaffold(
      appBar: AppBar(
        title: Text('Symptoms Screen'),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  children: [
                    sizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Day: '),
                        Container(
                          padding: EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(border: Border.all()),
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration.collapsed(
                              hintText: '',
                            ),
                            hint: Text('Select Day'),
                            value: _selectedDay,
                            items: _days.map(
                              (day) {
                                return DropdownMenuItem<String>(
                                  value: day,
                                  child: Text(day.capitalize()),
                                );
                              },
                            ).toList(),
                            onChanged: (day) {
                              setState(() {
                                _selectedDay = day!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    sizedBox,
                    symptomsOfDay == null || symptomsOfDay.isEmpty
                        ? Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: deviceSize.height / 3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('No Symptoms for this day'),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => AddSymptomsScreen(
                                            day: _selectedDay,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text('Add Symptoms'),
                                  )
                                ],
                              ),
                            ),
                          )
                        : symptomsOfDay.first == 'No Symptoms'
                            ? Padding(
                                padding:
                                    EdgeInsets.only(top: deviceSize.height / 3),
                                child: Center(
                                  child: Text('No Symptoms for this Day'),
                                ),
                              )
                            : ListView(
                                shrinkWrap: true,
                                children: symptomsOfDay
                                    .map(
                                      (sym) => Column(
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.all(0),
                                            title: Text(sym),
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                  ],
                ),
              ),
            ),
    );
  }
}
