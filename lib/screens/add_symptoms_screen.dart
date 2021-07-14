import 'package:covid_app/providers/auth.dart';
import 'package:covid_app/providers/operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSymptomsScreen extends StatefulWidget {
  final String day;
  const AddSymptomsScreen({
    Key? key,
    required this.day,
  }) : super(key: key);

  @override
  _AddSymptomsScreenState createState() => _AddSymptomsScreenState();
}

class _AddSymptomsScreenState extends State<AddSymptomsScreen> {
  bool _isLoading = false;
  TextEditingController _controller = TextEditingController();
  List<String> _defaultSymptoms = [
    'Fever',
    'Dry Cough',
    'Mucus or Phlegm',
    'Shortness of breath',
    'Loss of appetite',
    'Body aches',
  ];
  List<String> _selectedSymptoms = [];
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Symptoms for day ${widget.day}'),
      ),
      body: ListView(
        children: [
          Column(
            children: _defaultSymptoms
                .map(
                  (symptom) => CheckboxListTile(
                    title: Text(symptom),
                    value: _selectedSymptoms.contains(symptom),
                    onChanged: (selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedSymptoms.add(symptom);
                        } else {
                          _selectedSymptoms.remove(symptom);
                        }
                      });
                    },
                  ),
                )
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Add New Symptom',
                suffixIcon: TextButton.icon(
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      return;
                    }
                    setState(() {
                      _defaultSymptoms.add(_controller.text);
                      _selectedSymptoms.add(_controller.text);
                      print('added');
                      _controller.clear();
                      FocusScope.of(context).unfocus();
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add'),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(deviceSize.width - 16.0, 50),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_selectedSymptoms.length <= 0) {
                        await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            content: new Text(
                              'Didn\'t have any symptoms for this day?',
                            ),
                            actions: <Widget>[
                              new TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                                child: new Text('No'),
                              ),
                              new TextButton(
                                onPressed: () async {
                                  Navigator.of(ctx).pop(true);
                                  Provider.of<Operation>(context, listen: false)
                                      .savePatientSymptoms(
                                    Provider.of<Auth>(context, listen: false)
                                        .user!
                                        .id!,
                                    widget.day,
                                    ['No Symptoms'],
                                  ).then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          value
                                              ? 'Added Successfully'
                                              : 'Failed! try again later',
                                        ),
                                      ),
                                    );
                                  });
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          ),
                        ).then(
                          (value) {
                            setState(() {
                              _isLoading = false;
                            });
                            if (value == true) {
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      } else {
                        Provider.of<Operation>(context, listen: false)
                            .savePatientSymptoms(
                          Provider.of<Auth>(context, listen: false).user!.id!,
                          widget.day,
                          _selectedSymptoms,
                        )
                            .then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                value
                                    ? 'Saved Successfully'
                                    : 'Failed! try again later',
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
