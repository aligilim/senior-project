import 'package:covid_app/screens/check_user_location_screen.dart';
import 'package:covid_app/screens/quarantine_status_screen.dart';
import 'package:covid_app/widgets/grid_item_widget.dart';
import 'package:flutter/material.dart';

class HealthCareHomeWidget extends StatelessWidget {
  const HealthCareHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GridItemWidget(
            context: context,
            iconData: Icons.personal_injury_sharp,
            primaryColor: Colors.green,
            secondaryColor: Colors.green[900]!,
            text: "Quarantine Status",
            onPressed: () {
              Navigator.of(context).pushNamed(QuarantineStatusScreen.routeName);
            },
          ),
          GridItemWidget(
            context: context,
            iconData: Icons.location_history,
            primaryColor: Colors.yellow,
            secondaryColor: Colors.yellow[900]!,
            text: "Check user location",
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CheckUserLocationScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
