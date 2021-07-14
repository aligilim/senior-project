import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/providers/operation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../helpers/extensions.dart';

class CheckUserLocationScreen extends StatefulWidget {
  static const routeName = 'check-user-location-screen';
  CheckUserLocationScreen({Key? key}) : super(key: key);

  @override
  _CheckUserLocationScreenState createState() =>
      _CheckUserLocationScreenState();
}

class _CheckUserLocationScreenState extends State<CheckUserLocationScreen> {
  bool isInit = true;
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => PatientLocationScreen(
                                      patient: patient,
                                    ),
                                  ),
                                );
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
}

class PatientLocationScreen extends StatelessWidget {
  final UserData patient;
  const PatientLocationScreen({
    Key? key,
    required this.patient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();
    final deviceSize = MediaQuery.of(context).size;
    final distance = patient.currentLocation != null && patient.location != null
        ? Geolocator.distanceBetween(
            double.parse(patient.currentLati ?? '0.0'),
            double.parse(patient.currentLongi ?? '0.0'),
            double.parse(patient.lati ?? '0.0'),
            double.parse(patient.longi ?? '0.0'),
          )
        : 0.0;
    final Set<Polyline> _polyline = {};
    if (patient.currentLocation != null) {
      _polyline.add(
        Polyline(
          width: 2,
          polylineId: PolylineId('poly'),
          visible: true,
          points: [
            LatLng(
              double.parse(patient.lati ?? '0.0'),
              double.parse(patient.longi ?? '0.0'),
            ),
            LatLng(
              double.parse(patient.currentLati ?? '0.0'),
              double.parse(patient.currentLongi ?? '0.0'),
            ),
          ],
          color: Colors.red,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${patient.name} Location'),
      ),
      body: patient.location == null || patient.currentLocation == null
          ? Center(
              child: Text('User Location is UNKNOWN'),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: deviceSize.height / 1.8,
                    width: deviceSize.width - 40,
                    child: GoogleMap(
                      polylines: _polyline,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          double.parse(patient.lati ?? '0.0'),
                          double.parse(patient.longi ?? '0.0'),
                        ),
                        zoom: 10,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: {
                        Marker(
                          markerId: MarkerId('user-home'),
                          position: LatLng(
                            double.parse(patient.lati ?? '0.0'),
                            double.parse(patient.longi ?? '0.0'),
                          ),
                        ),
                        Marker(
                          markerId: MarkerId('user-location'),
                          position: LatLng(
                              double.parse(patient.currentLati ?? '0.0'),
                              double.parse(patient.currentLongi ?? '0.0')),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                      'Proximity from home: ${(distance / 1000).toStringAsFixed(2)} km'),
                  const SizedBox(height: 12.0),
                  if (distance <= 20)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('AT HOME'),
                        Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 30,
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('NOT AT HOME'),
                        Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30,
                        ),
                      ],
                    ),
                  ListTile(
                    title: Text('Send an e-mail to ${patient.name}'),
                    leading: Icon(Icons.email),
                    subtitle: Text(patient.email!),
                    onTap: () {
                      final Uri _emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: patient.email,
                      );

                      launch(_emailLaunchUri.toString());
                    },
                  ),
                  if (patient.phone != null)
                    ListTile(
                      title: Text('Call ${patient.name}'),
                      leading: Icon(Icons.call),
                      subtitle: Text(patient.phone!),
                      onTap: () => launch(
                        "tel://${patient.phone}",
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
