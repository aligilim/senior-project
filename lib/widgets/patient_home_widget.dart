import 'package:covid_app/screens/diseases_screen.dart';
import 'package:covid_app/screens/location_screen.dart';
import 'package:covid_app/screens/patient_profile_screen.dart';
import 'package:covid_app/screens/symptoms_screen.dart';
import 'package:covid_app/screens/test_result_screen.dart';
import 'package:covid_app/widgets/grid_item_widget.dart';
import 'package:flutter/material.dart';

class PatientHomeWidget extends StatelessWidget {
  const PatientHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 16.0),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GridItemWidget(
                  context: context,
                  iconData: Icons.health_and_safety_outlined,
                  primaryColor: Colors.green,
                  secondaryColor: Colors.green[900]!,
                  text: "Symptoms",
                  onPressed: () {
                    Navigator.of(context).pushNamed(SymptomsScreen.routeName);
                  },
                ),
                GridItemWidget(
                    context: context,
                    iconData: Icons.coronavirus,
                    primaryColor: Colors.yellow,
                    secondaryColor: Colors.yellow[900]!,
                    text: "Diseases",
                    onPressed: () {
                      Navigator.of(context).pushNamed(DiseasesScreen.routeName);
                    }),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GridItemWidget(
                  context: context,
                  iconData: Icons.quiz,
                  primaryColor: Colors.lightBlue,
                  secondaryColor: Colors.blue[900]!,
                  text: "Test Results",
                  onPressed: () {
                    Navigator.of(context).pushNamed(TestResultScreen.routeName);
                  },
                ),
                GridItemWidget(
                  context: context,
                  iconData: Icons.person,
                  primaryColor: Colors.purple,
                  secondaryColor: Colors.deepPurple,
                  text: "Profile",
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(PatientProfileScreen.routeName);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            GridItemWidget(
              context: context,
              iconData: Icons.location_history_rounded,
              primaryColor: Colors.brown,
              secondaryColor: Colors.brown[900]!,
              text: "Location",
              onPressed: () {
                Navigator.of(context).pushNamed(LocationScreen.routeName);
              },
            ),
          ],
        ),
      ],
    );
  }
}
