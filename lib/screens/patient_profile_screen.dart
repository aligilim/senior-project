import 'package:covid_app/providers/auth.dart';
import 'package:covid_app/screens/set_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../helpers/extensions.dart';

class PatientProfileScreen extends StatefulWidget {
  static const routeName = 'patient-profile-screen';
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).user!;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          if (isEdit)
            IconButton(
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
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
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a valid name';
              }
            },
            enabled: isEdit,
            initialValue: user.name.capitalize(),
            onSaved: (value) {},
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
          const SizedBox(height: 6.0),
          TextFormField(
            validator: (value) {
              if (int.parse(value!) > 120) {
                return 'Please add a valid age!';
              }
            },
            enabled: isEdit,
            initialValue: user.age ?? '',
            onSaved: (value) {},
            maxLines: 1,
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
          const SizedBox(height: 6.0),
          TextFormField(
            enabled: isEdit,
            initialValue: user.phone ?? '',
            onSaved: (value) {},
            maxLines: 1,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
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
          const SizedBox(height: 6.0),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (ctx) => SetLocationScreen(),
                ),
              )
                  .then((value) {
                List<String> values = value;
                // _locationController..text = values[0];
                // newArtist..location = values[0];
                // newArtist..latitude = values[1];
                // newArtist..longitude = values[2];
              });
            },
            child: TextFormField(
              enabled: false,
              onSaved: (value) {},
              maxLines: 1,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
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
          const SizedBox(height: 6.0),
          TextFormField(
            enabled: isEdit,
            initialValue: user.name.capitalize(),
            onSaved: (value) {},
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
          const SizedBox(height: 6.0),
          SwitchListTile(
            contentPadding: EdgeInsets.only(left: 4.0),
            title: Text('Have you been vaccinated?'),
            value: user.vaccinated,
            onChanged: (value) {},
          )
        ],
      ),
    );
  }
}
