import 'package:covid_app/screens/admin_analysis_screen.dart';
import 'package:covid_app/screens/analyze_patient_data_screen.dart';
import 'package:covid_app/screens/patients_info_screen.dart';
import 'package:covid_app/widgets/grid_item_widget.dart';
import 'package:flutter/material.dart';

class AdminHomeWidget extends StatelessWidget {
  const AdminHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GridItemWidget(
            context: context,
            iconData: Icons.medication_outlined,
            primaryColor: Colors.green,
            secondaryColor: Colors.green[900]!,
            text: "Analyze patient data",
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AnalyzePatientDataScreen.routeName);
            },
          ),
          GridItemWidget(
            context: context,
            iconData: Icons.health_and_safety_outlined,
            primaryColor: Colors.yellow,
            secondaryColor: Colors.yellow[900]!,
            text: "Create analysis report",
            onPressed: () {
              Navigator.of(context).pushNamed(AdminAnalysisScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
