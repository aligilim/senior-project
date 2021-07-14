import 'package:covid_app/models/user.dart';
import 'package:covid_app/providers/auth.dart';
import 'package:covid_app/screens/set_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../helpers/extensions.dart';

class PatientProfileScreen extends StatefulWidget {
  static const routeName = 'patient-profile-screen';
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _controller = TextEditingController();
  bool isEdit = false;
  List<String> genderList = [
    'Male',
    'Female',
    'Other',
  ];
  List<String> bloodList = [
    'A+',
    'B+',
    'AB+',
    'O+',
    'A-',
    'B-',
    'AB-',
    'O-',
  ];
  List<String> vaccineList = [
    'BionTech',
    'Sinovac',
    'Sputnik',
    'AstraZeneca',
    'Johnson-Johnson',
    'Sinopharm'
  ];
  String? newName;
  String? newAge;
  String? newPhone;
  String? newLocation;
  String? newLati;
  String? newLongi;
  String? newOccupation;
  String? selectedVaccine;
  String? selectedBlood;
  String? selectedGender;
  String? dose;
  DateTime? _selectedDate;
  bool? isVaccined;

  @override
  Widget build(BuildContext context) {
    const sizedbox = const SizedBox(height: 8.0);
    final user = Provider.of<Auth>(context).user!;
    _controller..text = newLocation ?? user.location ?? '';
    void _setVariablestoNull() {
      newName = null;
      newAge = null;
      newPhone = null;
      newLocation = null;
      newLati = null;
      newLongi = null;
      newOccupation = null;
      selectedVaccine = null;
      selectedBlood = null;
      selectedGender = null;
      dose = null;
      _selectedDate = null;
      isVaccined = null;
      _controller.text = user.location ?? '';
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          actions: [
            if (isEdit)
              IconButton(
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please Add Your Location!'),
                      ),
                    );
                    return;
                  }
                  if (!_formKey.currentState!.validate()) {
                    // Invalid!
                    return;
                  }
                  if (selectedBlood == null && user.bloodType == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please Select your Blood type!'),
                      ),
                    );
                    return;
                  }
                  if (selectedGender == null && user.gender == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please Select your Gender!'),
                      ),
                    );
                    return;
                  }
                  if (isVaccined == true || user.vaccinated) {
                    if (dose == null && user.vaccineData == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please Select a Dose!'),
                        ),
                      );
                      return;
                    }
                    if (selectedVaccine == null && user.vaccineData == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please Select a vaccine type!'),
                        ),
                      );
                      return;
                    }
                    if (_selectedDate == null && user.vaccineData == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please Select a vaccined date!'),
                        ),
                      );
                      return;
                    }
                  }
                  _formKey.currentState!.save();
                  setState(() {
                    isEdit = !isEdit;
                  });
                  print('Save');
                  Provider.of<Auth>(context, listen: false)
                      .savePatientProfile(
                    UserData(
                      age: newAge ?? user.age,
                      bloodType: selectedBlood ?? user.bloodType,
                      currentLati: user.currentLati,
                      currentLocation: user.currentLocation,
                      currentLongi: user.currentLongi,
                      email: user.email,
                      gender: selectedGender ?? user.gender,
                      id: user.id,
                      joinDate: user.joinDate,
                      lati: newLati ?? user.lati,
                      location: newLocation ?? user.location,
                      longi: newLongi ?? user.longi,
                      name: newName ?? user.name,
                      occupation: newOccupation ?? user.occupation,
                      phone: newPhone ?? user.phone,
                      type: user.type,
                      vaccinated: isVaccined ?? user.vaccinated,
                      vaccineData: isVaccined == true || user.vaccinated
                          ? VaccineData(
                              dose: dose ?? user.vaccineData!.dose,
                              dateOfVaccination: _selectedDate != null
                                  ? _selectedDateText
                                  : user.vaccineData!.dateOfVaccination,
                              vaccineType: selectedVaccine ??
                                  user.vaccineData!.vaccineType,
                            )
                          : null,
                    ),
                  )
                      .then((value) {
                    _setVariablestoNull();
                  });
                },
                icon: Icon(
                  Icons.check_rounded,
                ),
              )
            else
              IconButton(
                onPressed: () {
                  setState(() {
                    isEdit = !isEdit;
                  });
                },
                icon: Icon(
                  Icons.mode_edit_outline_rounded,
                ),
              ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid name';
                      }
                    },
                    enabled: isEdit,
                    initialValue: user.name.capitalize(),
                    onSaved: (value) {
                      newName = value;
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
                      icon: Icon(Icons.person_outlined),
                      labelText: 'Name',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  sizedbox,
                  TextFormField(
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.parse(value) > 120) {
                        return 'Please add a valid age!';
                      }
                    },
                    enabled: isEdit,
                    initialValue: user.age ?? '',
                    onSaved: (value) {
                      newAge = value;
                    },
                    maxLines: 1,
                    maxLength: isEdit ? 3 : null,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
                      icon: Icon(Icons.date_range),
                      labelText: 'Age',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  sizedbox,
                  TextFormField(
                    enabled: isEdit,
                    initialValue: user.phone ?? '',
                    onSaved: (value) {
                      newPhone = value;
                    },
                    validator: (value) {
                      if (value == null || value.length < 13) {
                        return 'Phone number is not valid';
                      }
                    },
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      // FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\+]'))
                    ],
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
                      icon: Icon(Icons.phone),
                      labelText: 'Phone Number',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  sizedbox,
                  GestureDetector(
                    onTap: !isEdit
                        ? null
                        : () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (ctx) => SetLocationScreen(),
                              ),
                            )
                                .then((value) {
                              if (value == null) {
                                return;
                              }
                              List<String> values = value;
                              setState(() {
                                newLocation = values[0];
                                newLati = values[1];
                                newLongi = values[2];
                                _controller.text = value[0];
                              });
                            });
                          },
                    child: TextFormField(
                      controller: _controller,
                      enabled: false,
                      onSaved: (value) {
                        newLocation = value;
                      },
                      maxLines: 2,
                      minLines: 1,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 24.0),
                        icon: Icon(Icons.location_on),
                        labelText: 'Your Location',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  sizedbox,
                  TextFormField(
                    enabled: isEdit,
                    initialValue: user.occupation,
                    onSaved: (value) {
                      newOccupation = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid occupation';
                      }
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
                      icon: Icon(Icons.work),
                      labelText: 'Occupation',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sizedbox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Blood type: '),
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
                    hint: Text(isEdit ? 'Select Type' : 'Unknown'),
                    value: isEdit
                        ? selectedBlood ?? user.bloodType
                        : user.bloodType,
                    items: bloodList.map(
                      (el) {
                        print(el);
                        return DropdownMenuItem<String>(
                          value: el,
                          child: Text(el),
                        );
                      },
                    ).toList(),
                    onChanged: isEdit
                        ? (type) {
                            setState(() {
                              selectedBlood = type;
                              print(type);
                            });
                          }
                        : null,
                  ),
                ),
              ],
            ),
            sizedbox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gender: '),
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
                    hint: Text(isEdit ? 'Select Gender' : 'Unknown'),
                    value: isEdit ? selectedGender ?? user.gender : user.gender,
                    items: genderList.map(
                      (gender) {
                        print(gender);
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      },
                    ).toList(),
                    onChanged: isEdit
                        ? (gender) {
                            setState(() {
                              selectedGender = gender;
                              print(gender);
                            });
                          }
                        : null,
                  ),
                ),
              ],
            ),
            sizedbox,
            if (!user.vaccinated && isEdit)
              SwitchListTile(
                contentPadding: EdgeInsets.only(left: 4.0),
                title: Text('Have you been vaccinated?'),
                value: isVaccined ?? user.vaccinated,
                onChanged: (value) {
                  setState(() {
                    isVaccined = value;
                  });
                },
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vaccine Data:'),
                  Text(
                    user.vaccinated == true
                        ? 'Vaccinated'
                        : 'Not vaccinated yet',
                  ),
                ],
              ),
            sizedbox,
            if (isEdit && isVaccined == true || user.vaccinated)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dose: '),
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
                          hint: Text(isEdit ? 'Select' : 'Unknown'),
                          value: isEdit && dose != null
                              ? dose
                              : user.vaccinated
                                  ? user.vaccineData!.dose
                                  : null,
                          items: ['One', 'Two'].map(
                            (i) {
                              print(i);
                              return DropdownMenuItem<String>(
                                value: i,
                                child: Text(i),
                              );
                            },
                          ).toList(),
                          onChanged: isEdit
                              ? (val) {
                                  setState(() {
                                    dose = val;
                                    print(val);
                                  });
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  sizedbox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Vaccine Type: '),
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
                          hint: Text(isEdit ? 'Select Vaccine' : 'Unknown'),
                          value: isEdit && selectedVaccine != null
                              ? selectedVaccine
                              : user.vaccinated
                                  ? user.vaccineData!.vaccineType
                                  : null,
                          items: vaccineList.map(
                            (vaccine) {
                              print(vaccine);
                              return DropdownMenuItem<String>(
                                value: vaccine,
                                child: Text(vaccine),
                              );
                            },
                          ).toList(),
                          onChanged: isEdit
                              ? (vaccine) {
                                  setState(() {
                                    selectedVaccine = vaccine;
                                    print(vaccine);
                                  });
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  sizedbox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date of Vaccination'),
                      TextButton(
                        onPressed: isEdit
                            ? () {
                                _showDatePicker();
                              }
                            : null,
                        child: Text(
                          isEdit
                              ? _selectedDate == null
                                  ? user.vaccinated
                                      ? user.vaccineData!.dateOfVaccination
                                      : 'SelectDate'
                                  : _selectedDateText
                              : user.vaccinated
                                  ? user.vaccineData!.dateOfVaccination
                                  : 'Unknown',
                        ),
                      ),
                    ],
                  ),
                ],
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
