import 'package:covid_app/providers/auth.dart';
import 'package:covid_app/providers/operation.dart';
import 'package:covid_app/screens/add_medical_report_screen.dart';
import 'package:covid_app/screens/add_test_result_screen.dart';
import 'package:covid_app/screens/admin_analysis_screen.dart';
import 'package:covid_app/screens/analyze_patient_data_screen.dart';
import 'package:covid_app/screens/auth_screen.dart';
import 'package:covid_app/screens/check_user_location_screen.dart';
import 'package:covid_app/screens/diseases_screen.dart';
import 'package:covid_app/screens/home_screen.dart';
import 'package:covid_app/screens/location_screen.dart';
import 'package:covid_app/screens/patient_profile_screen.dart';
import 'package:covid_app/screens/patients_info_screen.dart';
import 'package:covid_app/screens/quarantine_status_screen.dart';
import 'package:covid_app/screens/sign_up_screen.dart';
import 'package:covid_app/screens/splash_screen.dart';
import 'package:covid_app/screens/symptoms_analysis_screen.dart';
import 'package:covid_app/screens/symptoms_screen.dart';
import 'package:covid_app/screens/test_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Operation>(
          create: (_) => Operation(),
          update: (_, auth, previousServices) {
            previousServices?..authToken = auth.token ?? '';
            return previousServices!;
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Covid App',
          theme: ThemeData(
            primaryColor: Colors.deepPurple,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            buttonColor: Colors.cyan,
            accentColor: Colors.cyan,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
            backgroundColor: Colors.white,
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            SignUpScreen.routeName: (ctx) => SignUpScreen(),
            PatientProfileScreen.routeName: (ctx) => PatientProfileScreen(),
            SymptomsScreen.routeName: (ctx) => SymptomsScreen(),
            DiseasesScreen.routeName: (ctx) => DiseasesScreen(),
            LocationScreen.routeName: (ctx) => LocationScreen(),
            TestResultScreen.routeName: (ctx) => TestResultScreen(),
            AddMedicalReportScreen.routeName: (ctx) => AddMedicalReportScreen(),
            SymptomsAnalysisScreen.routeName: (ctx) => SymptomsAnalysisScreen(),
            CheckUserLocationScreen.routeName: (ctx) =>
                CheckUserLocationScreen(),
            QuarantineStatusScreen.routeName: (ctx) => QuarantineStatusScreen(),
            PatientsInfoScreen.routeName: (ctx) => PatientsInfoScreen(),
            AdminAnalysisScreen.routeName: (ctx) => AdminAnalysisScreen(),
            AddTestResultScreen.routeName: (ctx) => AddTestResultScreen(),
            AnalyzePatientDataScreen.routeName: (ctx) =>
                AnalyzePatientDataScreen(),
          },
        ),
      ),
    );
  }
}
