import 'dart:async';
import 'package:covid_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  static const routeName = 'location-screen';
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  bool isInit = true;
  bool hasPermission = false;
  final Set<Polyline> _polyline = {};

  @override
  void didChangeDependencies() {
    if (isInit) {
      Geolocator.checkPermission().then((value) {
        if (value == LocationPermission.deniedForever) {
          setState(() {
            isInit = false;
            hasPermission = false;
          });
          return;
        } else if (value == LocationPermission.denied) {
          Geolocator.requestPermission().then((permission) {
            setState(() {
              isInit = false;
            });
            if (permission == LocationPermission.whileInUse ||
                permission == LocationPermission.always) {
              setState(() {
                hasPermission = true;
              });
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
              setState(() {
                isInit = false;
                hasPermission = true;
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
    final deviceSize = MediaQuery.of(context).size;
    final user = Provider.of<Auth>(context).user!;
    final distance = user.currentLocation != null && user.location != null
        ? Geolocator.distanceBetween(
            double.parse(user.currentLati ?? '0.0'),
            double.parse(user.currentLongi ?? '0.0'),
            double.parse(user.lati ?? '0.0'),
            double.parse(user.longi ?? '0.0'),
          )
        : 0.0;
    if (user.currentLocation != null) {
      _polyline.add(
        Polyline(
          width: 2,
          polylineId: PolylineId('poly'),
          visible: true,
          points: [
            LatLng(
              double.parse(user.lati ?? '0.0'),
              double.parse(user.longi ?? '0.0'),
            ),
            LatLng(
              double.parse(user.currentLati ?? '0.0'),
              double.parse(user.currentLongi ?? '0.0'),
            ),
          ],
          color: Colors.red,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Location Screen'),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : hasPermission
              ? Column(
                  children: [
                    Container(
                      height: deviceSize.height / 1.5,
                      width: deviceSize.width,
                      child: GoogleMap(
                        polylines: _polyline,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(user.lati ?? '0.0'),
                              double.parse(user.longi ?? '0.0'),
                            ),
                            zoom: 14),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: {
                          Marker(
                            markerId: MarkerId('user-home'),
                            position: LatLng(
                              double.parse(user.lati ?? '0.0'),
                              double.parse(user.longi ?? '0.0'),
                            ),
                          ),
                          Marker(
                            markerId: MarkerId('user-location'),
                            position: LatLng(
                                double.parse(user.currentLati ?? '0.0'),
                                double.parse(user.currentLongi ?? '0.0')),
                          ),
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                        'Proximity from home: ${(distance / 1000).toStringAsFixed(2)} km'),
                    const SizedBox(height: 16.0),
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
                  ],
                )
              : Center(
                  child: Text('Location Permission required for this page'),
                ),
    );
  }
}
