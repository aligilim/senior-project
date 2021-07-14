import 'package:flutter/material.dart';
import 'package:covid_app/models/medical_report.dart';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/providers/auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:covid_app/providers/operation.dart';
import '../helpers/extensions.dart';

class CreateMedicalReport extends StatefulWidget {
  final UserData patient;
  const CreateMedicalReport({
    Key? key,
    required this.patient,
  }) : super(key: key);

  @override
  _CreateMedicalReportState createState() => _CreateMedicalReportState();
}

class _CreateMedicalReportState extends State<CreateMedicalReport> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _dragController = TextEditingController();
  DateTime? _selectedDate;
  List<String> drugs = [];
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).user!;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.patient.name.capitalize()} Report'),
        ),
        body: ListView(
          padding: EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 8.0,
          ),
          children: [
            TextField(
              maxLines: 6,
              minLines: 3,
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                icon: const Icon(Icons.description),
                labelText: 'diagnosis',
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Drugs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: drugs.length <= 0
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Add Drugs here.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: drugs
                          .map(
                            (item) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.capitalize()),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      drugs.remove(item);
                                      print('removed');
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
            ),
            TextField(
              controller: _dragController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Add New Drug',
                suffixIcon: TextButton.icon(
                  onPressed: () {
                    if (_dragController.text.isEmpty) {
                      return;
                    }
                    setState(() {
                      drugs.add(_dragController.text);
                      print('added');
                      _dragController.clear();
                      FocusScope.of(context).unfocus();
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add'),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Report Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    _showDatePicker();
                  },
                  child: Text(
                    _selectedDate == null ? 'SelectDate' : _selectedDateText,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(MediaQuery.of(context).size.width - 16.0, 50),
                  ),
                ),
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please Add a Diagnosis'),
                      ),
                    );
                    return;
                  }
                  if (drugs.length <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please Add at least one Drug'),
                      ),
                    );
                    return;
                  }
                  if (_selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please Add a Date'),
                      ),
                    );
                    return;
                  }
                  setState(() {
                    _isLoading = true;
                  });
                  Provider.of<Operation>(context, listen: false)
                      .addMedicalReport(
                    MedicalReport(
                      date: _selectedDateText,
                      diagnosis: _controller.text,
                      doctorId: user.id!,
                      doctorName: user.name!,
                      drugs: drugs,
                      patientId: widget.patient.id!,
                      patientName: widget.patient.name!,
                    ),
                  )
                      .then((value) {
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value
                              ? 'Added Successfully'
                              : 'Faild! try again later!',
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  });
                },
                child: Text(
                  'SAVE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String get _selectedDateText {
    return DateFormat.yMMMd().format(_selectedDate!);
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    setState(() {
      _selectedDate = picked;
    });
  }
}
