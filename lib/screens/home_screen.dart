import 'package:covid_app/providers/auth.dart';
import 'package:covid_app/widgets/admin_home_widget.dart';
import 'package:covid_app/widgets/doctor_home_widget.dart';
import 'package:covid_app/widgets/healthcare_home_widget.dart';
import 'package:covid_app/widgets/patient_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      isInit = false;
      Geolocator.checkPermission().then((value) {
        if (value == LocationPermission.deniedForever) {
          return;
        } else if (value == LocationPermission.denied) {
          Geolocator.requestPermission().then((permission) {
            if (permission == LocationPermission.whileInUse ||
                permission == LocationPermission.always) {
              Geolocator.getCurrentPosition().then((position) {
                placemarkFromCoordinates(position.latitude, position.longitude,
                        localeIdentifier: 'en_US')
                    .then((newPlace) {
                  print(
                      '${newPlace[0].locality}, ${newPlace[0].administrativeArea}, ${newPlace[0].country}');
                  Provider.of<Auth>(context, listen: false)
                      .setUserCurrentLocation(
                    location:
                        '${newPlace[0].locality}, ${newPlace[0].administrativeArea}, ${newPlace[0].country}',
                    lati: '${position.latitude}',
                    longi: '${position.longitude}',
                  );
                });

                print(
                  'lat: ${position.latitude}, long: ${position.longitude}',
                );
              });
            }
          });
        } else if (value == LocationPermission.whileInUse ||
            value == LocationPermission.always) {
          Geolocator.getCurrentPosition().then(
            (position) {
              placemarkFromCoordinates(position.latitude, position.longitude,
                      localeIdentifier: 'en_US')
                  .then((newPlace) {
                print(
                    '${newPlace[0].locality}, ${newPlace[0].administrativeArea}, ${newPlace[0].country}');
                Provider.of<Auth>(context, listen: false)
                    .setUserCurrentLocation(
                  location:
                      '${newPlace[0].locality}, ${newPlace[0].administrativeArea}, ${newPlace[0].country}',
                  lati: '${position.latitude}',
                  longi: '${position.longitude}',
                );
              });

              print(
                'lat: ${position.latitude}, long: ${position.longitude}',
              );
            },
          );
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).user!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
        title: Text('Covid-19 Health Monitoring Application'),
      ),
      body: user.type == 'Patient'
          ? PatientHomeWidget()
          : user.type == 'Doctor'
              ? DoctorHomeWidget()
              : user.type == 'Healthcare Personnel'
                  ? HealthCareHomeWidget()
                  : user.type == 'Admin'
                      ? AdminHomeWidget()
                      : Center(
                          child: Text('${user.type} Side!'),
                        ),
    );
  }
}
