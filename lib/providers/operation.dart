import 'dart:convert';

// import 'package:covid_app/helpers/db_helper.dart';
import 'package:covid_app/models/db_item.dart';
import 'package:covid_app/models/disease.dart';
import 'package:covid_app/models/medical_report.dart';
import 'package:covid_app/models/quarantine_item.dart';
import 'package:covid_app/models/symptom.dart';
import 'package:covid_app/models/test_result.dart';
import 'package:covid_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Operation with ChangeNotifier {
  static const base_url = 'covid-app-b1807-default-rtdb.firebaseio.com';
  String? _authToken;
  set authToken(String? value) {
    _authToken = value;
  }

  // patient symptoms
  Map<String, List<String>> _symptoms = {
    'one': [],
    'two': [],
    'three': [],
    'four': [],
    'five': [],
    'six': [],
    'seven': [],
    'eight': [],
    'nine': [],
    'ten': [],
    'eleven': [],
    'twelve': [],
    'thirteen': [],
    'fourteen': [],
  };
  Map<String, List<String>> get symptoms {
    return {..._symptoms};
  }

  // patient test results
  List<TestResult> _testResults = [];
  List<TestResult> get testResults {
    return [..._testResults];
  }

  //patient diseases
  List<Disease> _diseases = [];
  List<Disease> get diseases {
    return [..._diseases];
  }

  // Patients List
  List<UserData> _patients = [];
  List<UserData> get patients {
    return [..._patients];
  }

  // Medical Reports List
  List<MedicalReport> _medicalReports = [];
  List<MedicalReport> get medicalReports {
    return [..._medicalReports];
  }

  // quarantine Data
  List<QuarantineItem> _quarantineData = [];
  List<QuarantineItem> get quarantineData {
    return [..._quarantineData];
  }

  // SQLITE Symptoms data
  List<Symptoms> _sqlSymptoms = [];
  List<Symptoms> _sqlSymptomsOfDay = [];
  List<Symptoms> get sqlSymptomsOfDay {
    return [..._sqlSymptomsOfDay];
  }

  List<Symptoms> get sqlSymptoms {
    return [..._sqlSymptoms];
  }

  void filterSqlSymptomsByDay(String day) {
    _sqlSymptomsOfDay = [..._sqlSymptoms];
    _sqlSymptomsOfDay =
        _sqlSymptomsOfDay.where((item) => item.day == day).toList();
    notifyListeners();
  }

  // Symptoms Data
  List<Symptoms> _symptomsList = [];
  List<Symptoms> _symptomsOfDay = [];
  List<Symptoms> get symptomsOfDay {
    return [..._symptomsOfDay];
  }

  List<Symptoms> get symptomsList {
    return [..._symptomsList];
  }

  void filterSymptomsByDay(String day) {
    _symptomsOfDay = [..._symptomsList];
    _symptomsOfDay = _symptomsOfDay.where((item) => item.day == day).toList();
    notifyListeners();
  }

  // database items
  List<DBItem> _databaseItems = [];
  List<DBItem> _filteredDbItems = [];
  List<DBItem> get databaseItems {
    return [..._databaseItems];
  }

  List<DBItem> get filteredDbItems {
    return [..._filteredDbItems];
  }

  void filterDbItems(String country, String age, String gender) {
    _filteredDbItems = [..._databaseItems];
    if (country != 'All') {
      _filteredDbItems =
          _filteredDbItems.where((item) => item.country == country).toList();
    }
    if (age != 'All') {
      if (age == '0-9') {
        _filteredDbItems =
            _filteredDbItems.where((item) => item.age0To9).toList();
      } else if (age == '10-19') {
        _filteredDbItems =
            _filteredDbItems.where((item) => item.age10to19).toList();
      } else if (age == '20-24') {
        _filteredDbItems =
            _filteredDbItems.where((item) => item.age20to24).toList();
      } else if (age == '25-59') {
        _filteredDbItems =
            _filteredDbItems.where((item) => item.age25to59).toList();
      } else if (age == '60+') {
        _filteredDbItems =
            _filteredDbItems.where((item) => item.age60).toList();
      }
    }
    if (gender != 'All') {
      if (gender == 'Male') {
        _filteredDbItems = _filteredDbItems.where((item) => item.male).toList();
      } else if (gender == 'Female') {
        _filteredDbItems =
            _filteredDbItems.where((item) => item.female).toList();
      } else if (gender == 'Other') {
        _filteredDbItems =
            _filteredDbItems.where((item) => item.other).toList();
      }
    }
    notifyListeners();
  }

  // Future<void> insertPatientsToSQL() async {
  //   try {
  //     data.forEach((key, value) async {
  //       final response = await http.post(
  //         Uri.parse(
  //             "https://covid-flutter.000webhostapp.com/insert_patient.php"),
  //         body: {
  //           "id": key,
  //           'bloodType': value['blood_type'] ?? '',
  //           'currentLocation': value['current_location'] == null
  //               ? ''
  //               : value['current_location']['location']
  //                   .toString()
  //                   .split(',')
  //                   .last,
  //           'currentLati': value['current_location'] == null
  //               ? ''
  //               : value['current_location']['lati'] ?? '',
  //           'currentLongi': value['current_location'] == null
  //               ? ''
  //               : value['current_location']['longi'] ?? '',
  //           'age': value['age'] ?? '',
  //           'email': value['email'] ?? '',
  //           'fullname': value['fullname'] ?? '',
  //           'gender': value['gender'] ?? '',
  //           'joinTime': value['joinTime'] ?? '',
  //           'location': value['location'] == null
  //               ? ''
  //               : value['location']['location'].toString().split(',').last,
  //           'lati': value['location'] == null
  //               ? ''
  //               : value['location']['lati'] ?? '',
  //           'longi': value['location'] == null
  //               ? ''
  //               : value['location']['longi'] ?? '',
  //           'occupation': value['occupation'] ?? '',
  //           'phone': value['phone'] ?? '',
  //           'userType': value['userType'] ?? '',
  //           'vaccinated': value['vaccinated'] == true ? '1' : '0',
  //           'dateOfVaccination': value['vaccinated'] == true
  //               ? value['vaccine_data']['dateOfVaccination'] ?? ''
  //               : '',
  //           'dose': value['vaccinated'] == true
  //               ? value['vaccine_data']['dose'] ?? ''
  //               : '',
  //           'vaccineType': value['vaccinated'] == true
  //               ? value['vaccine_data']['vaccineType'] ?? ''
  //               : '',
  //         },
  //         headers: {
  //           "Accept": "application/json",
  //         },
  //       );
  //       print('SQL: ${response.body}');
  //     });
  //   } catch (err) {
  //     throw err;
  //   }
  // }

  Future<void> getSQLPatients() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://covid-flutter.000webhostapp.com/get_patients.php",
        ),
      );
      final dataList =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      print('SQL: ${response.body}');
      // final List<Symptoms> _symptoms = [];
      // dataList
      //     .map(
      //       (item) => item.forEach((key, value) {
      //         print(
      //             '${value.toString().replaceAll('[', '').replaceAll(']', '')}');
      //         if (key == 'id' || value.isEmpty) {
      //           return;
      //         }
      //         _symptoms.add(
      //           Symptoms(
      //             day: key,
      //             symptomsOfDay: value
      //                 .toString()
      //                 .replaceAll('[', '')
      //                 .replaceAll(']', '')
      //                 .split(','),
      //             userId: dataList.indexOf(item).toString(),
      //           ),
      //         );
      //       }),
      //     )
      //     .toList();
      // print('SQLITE: ${_symptoms.length}');
      // _sqlSymptoms = _symptoms;
      // notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getSQLSymptoms() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://covid-flutter.000webhostapp.com/get_symptoms.php",
        ),
      );
      final dataList =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      print('SQL: ${response.body}');
      final List<Symptoms> _symptoms = [];
      dataList
          .map(
            (item) => item.forEach((key, value) {
              print(
                  '${value.toString().replaceAll('[', '').replaceAll(']', '')}');
              if (key == 'id' || value.isEmpty) {
                return;
              }
              _symptoms.add(
                Symptoms(
                  day: key,
                  symptomsOfDay: value
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', '')
                      .split(','),
                  userId: dataList.indexOf(item).toString(),
                ),
              );
            }),
          )
          .toList();
      print('SQLITE: ${_symptoms.length}');
      _sqlSymptoms = _symptoms;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  // Future<void> fetchDatabaseItems() async {
  //   final dataList = await DBHelper.getData('cov_db');
  //   _databaseItems = dataList
  //       .map(
  //         (item) => DBItem(
  //           age0To9: item['Age_0-9'] == 1,
  //           age10to19: item['Age_10-19'] == 1,
  //           age20to24: item['Age_20-24'] == 1,
  //           age25to59: item['Age_25-59'] == 1,
  //           age60: item['Age_60+'] == 1,
  //           male: item['Gender_Male'] == 1,
  //           female: item['Gender_Female'] == 1,
  //           other: item['Gender_Transgender'] == 1,
  //           country: item['Country'],
  //           difficultyInBreathing: item['Difficulty-in-Breathing'] == 1,
  //           dryCough: item['Dry-Cough'] == 1,
  //           runnyNose: item['Runny-Nose'] == 1,
  //           fever: item['Fever'] == 1,
  //           noneSympton: item['None_Sympton'] == 1,
  //           pains: item['Pains'] == 1,
  //           severityMild: item['Severity_Mild'] == 1,
  //           severityModerate: item['Severity_Moderate'] == 1,
  //           severityNone: item['Severity_None'] == 1,
  //           severitySevere: item['Severity_Severe'] == 1,
  //           soreThroat: item['Sore-Throat'] == 1,
  //           tiredness: item['Tiredness'] == 1,
  //         ),
  //       )
  //       .toList();
  //   print('Database: ${_databaseItems.length}');
  //   filterDbItems('All', 'All', 'All');
  // }

  Future<void> getPatients() async {
    _patients = [];
    var uri = Uri.https(
      base_url,
      'users.json',
      {
        'auth': _authToken,
        'orderBy': json.encode('userType'),
        'equalTo': json.encode('Patient'),
      },
    );
    try {
      final response = await http.get(uri);
      print('userInfo: ${response.body}');
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final List<UserData> loadedPatients = [];
      responseData.forEach((userId, userData) {
        loadedPatients.add(
          UserData(
            id: userId,
            currentLati: userData['current_location'] != null
                ? userData['current_location']['lati']
                : null,
            currentLongi: userData['current_location'] != null
                ? userData['current_location']['longi']
                : null,
            age: userData['age'],
            bloodType: userData['blood_type'],
            phone: userData['phone'],
            gender: userData['gender'],
            occupation: userData['occupation'],
            joinDate: userData['joinTime'],
            vaccinated: userData['vaccinated'] ?? false,
            vaccineData: userData['vaccine_data'] == null
                ? null
                : VaccineData(
                    dose: userData['vaccine_data']['dose'],
                    dateOfVaccination: userData['vaccine_data']
                        ['dateOfVaccination'],
                    vaccineType: userData['vaccine_data']['vaccineType'],
                  ),
            email: userData['email'],
            location: userData['location'] != null
                ? userData['location']['location']
                : null,
            type: userData['userType'],
            name: userData['fullname'],
            lati: userData['location'] != null
                ? userData['location']['lati']
                : null,
            longi: userData['location'] != null
                ? userData['location']['longi']
                : null,
            currentLocation: userData['current_location'] != null
                ? userData['current_location']['location']
                : null,
          ),
        );
      });
      _patients = loadedPatients;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getAllSymptoms() async {
    var uri = Uri.https(base_url, 'symptoms.json', {'auth': _authToken});
    try {
      final response = await http.get(uri);
      if (response.statusCode >= 400) {
        return;
      }
      if (response.body == 'null' || response.body.isEmpty) {
        return;
      }
      final List<Symptoms> symptoms = [];
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      responseData.forEach((id, value) {
        final data = Map<String, dynamic>.from(value);
        data.forEach((day, value) {
          final symList = List<dynamic>.from(value);
          symptoms.add(
            Symptoms(
              day: day,
              symptomsOfDay: symList.map((e) => e.toString()).toList(),
              userId: id,
            ),
          );
        });
      });
      _symptomsList = symptoms;
      notifyListeners();
      filterSymptomsByDay('one');
    } catch (err) {
      throw err;
    }
  }

  Future<void> getPatientSymptoms(String patientId) async {
    _symptoms = {
      'one': [],
      'two': [],
      'three': [],
      'four': [],
      'five': [],
      'six': [],
      'seven': [],
      'eight': [],
      'nine': [],
      'ten': [],
      'eleven': [],
      'twelve': [],
      'thirteen': [],
      'fourteen': [],
    };
    var uri =
        Uri.https(base_url, 'symptoms/$patientId.json', {'auth': _authToken});
    try {
      final response = await http.get(uri);
      print('symptoms: ${response.body}');
      if (response.statusCode >= 400) {
        return;
      }
      if (response.body == 'null' || response.body.isEmpty) {
        return;
      }
      Map<String, List<String>> loadedData = {};
      final responseData =
          Map<String, List<dynamic>>.from(json.decode(response.body));
      responseData.forEach((key, value) {
        loadedData[key] = value.map((e) => e.toString()).toList();
      });
      _symptoms = loadedData;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<bool> addTestResult(TestResult newResult, String patientId) async {
    var uri = Uri.https(
      base_url,
      'test_results/$patientId.json',
      {'auth': _authToken},
    );
    try {
      final response = await http.post(
        uri,
        body: json.encode(
          {
            'date': newResult.date,
            'patientName': newResult.patientName,
            'patientEmail': newResult.patientEmail,
            'positive': newResult.positive,
          },
        ),
      );
      print('test_results: ${response.body}');
      if (response.statusCode >= 400) {
        return false;
      }
      return true;
    } catch (err) {
      throw err;
    }
  }

  Future<void> getTestResult(String patientId) async {
    _testResults = [];
    var uri = Uri.https(
      base_url,
      'test_results/$patientId.json',
      {'auth': _authToken},
    );
    try {
      final response = await http.get(uri);
      print('test_results: ${response.body}');
      if (response.statusCode >= 400) {
        return;
      }
      if (response.body == 'null' || response.body.isEmpty) {
        return;
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final List<TestResult> loadedResults = [];
      responseData.forEach((key, test) {
        loadedResults.add(
          TestResult(
            date: test['date'],
            patientName: test['patientName'],
            patientEmail: test['patientEmail'],
            positive: test['positive'],
          ),
        );
      });

      _testResults = loadedResults;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getPatientDiseases(String patientId) async {
    _diseases = [];
    var uri =
        Uri.https(base_url, 'diseases/$patientId.json', {'auth': _authToken});
    try {
      final response = await http.get(uri);
      print('diseases: ${response.body}');
      if (response.statusCode >= 400) {
        return;
      }
      if (response.body == 'null' || response.body.isEmpty) {
        return;
      }
      final responseData = json.decode(response.body) as List<dynamic>;
      final fetchedDiseases = responseData
          .map(
            (item) => Disease(
              name: item['name'],
              isChronicle: item['isChronicle'],
            ),
          )
          .toList();
      _diseases = fetchedDiseases;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getQuarantineData(String patientId) async {
    _quarantineData = [];
    var uri = Uri.https(
      base_url,
      'quarantine/$patientId.json',
      {'auth': _authToken},
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode >= 400) {
        return;
      }
      if (response.body == 'null' || response.body.isEmpty) {
        return;
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      List<QuarantineItem> fetchedData = [];
      responseData.forEach((key, data) {
        fetchedData.add(
          QuarantineItem(
            date: data['date'],
            isHome: data['isHome'],
            latitude: data['latitude'],
            location: data['location'],
            longitude: data['longitude'],
          ),
        );
        _quarantineData = fetchedData;
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> getMedicalReports(String doctorId) async {
    _medicalReports = [];
    var uri = Uri.https(
      base_url,
      'medical_reports.json',
      {
        'auth': _authToken,
        'orderBy': json.encode('doctor_id'),
        'equalTo': json.encode(doctorId),
      },
    );
    try {
      final response = await http.get(uri);
      print('medical Reports: ${response.body}');
      if (response.statusCode >= 400) {
        return;
      }
      if (response.body == 'null' || response.body.isEmpty) {
        return;
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      List<MedicalReport> fetchedReports = [];
      responseData.forEach((reportId, data) {
        fetchedReports.add(
          MedicalReport(
            id: reportId,
            date: data['date'],
            diagnosis: data['diagnosis'],
            doctorId: data['doctor_id'],
            doctorName: data['doctor_name'],
            drugs: List<String>.from(data['drugs']),
            patientId: data['patient_id'],
            patientName: data['patient_name'],
          ),
        );
      });
      _medicalReports = fetchedReports;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<bool> addMedicalReport(MedicalReport medicalReport) async {
    var uri = Uri.https(base_url, 'medical_reports.json', {'auth': _authToken});
    try {
      final response = await http.post(
        uri,
        body: json.encode({
          'date': medicalReport.date,
          'diagnosis': medicalReport.diagnosis,
          'doctor_id': medicalReport.doctorId,
          'patient_id': medicalReport.patientId,
          'drugs': medicalReport.drugs,
          'doctor_name': medicalReport.doctorName,
          'patient_name': medicalReport.patientName,
        }),
      );
      print('Add MedicalReport: ${response.body}');
      if (response.statusCode >= 400) {
        return false;
      }
      getMedicalReports(medicalReport.doctorId);
      return true;
    } catch (err) {
      throw err;
    }
  }

  Future<bool> savePatientSymptoms(
    String patientId,
    String day,
    List<String> symptoms,
  ) async {
    var uri = Uri.https(
        base_url, 'symptoms/$patientId/$day.json', {'auth': _authToken});
    try {
      final response = await http.put(
        uri,
        body: json.encode(symptoms),
      );
      print(response.body);
      if (response.statusCode >= 400) {
        return false;
      }
      _symptoms[day] = symptoms;
      notifyListeners();
      saveSymptomsToSql(patientId, _symptoms);
      return true;
    } catch (err) {
      throw err;
    }
  }

  Future<void> saveSymptomsToSql(String key, dynamic value) async {
    final response = await http.post(
      Uri.parse("https://covid-flutter.000webhostapp.com/insert_symptoms.php"),
      body: {
        "id": key,
        "one": value['one'] ?? '',
        "two": value['two'] ?? '',
        "three": value['three'] ?? '',
        "four": value['four'] ?? '',
        "five": value['five'] ?? '',
        "six": value['six'] ?? '',
        "seven": value['seven'] ?? '',
        "eight": value['eight'] ?? '',
        "nine": value['nine'] ?? '',
        "ten": value['ten'] ?? '',
        "eleven": value['eleven'] ?? '',
        "twelve": value['twelve'] ?? '',
        "thirteen": value['thirteen'] ?? '',
        "fourteen": value['fourteen'] ?? '',
      },
      headers: {
        "Accept": "application/json",
      },
    );
  }

  Future<bool> addNewDisease(
    String patientId,
    Disease newDisease,
  ) async {
    _diseases.add(newDisease);
    notifyListeners();
    var uri =
        Uri.https(base_url, 'diseases/$patientId.json', {'auth': _authToken});
    try {
      final response = await http.put(
        uri,
        body: json.encode(_diseases
            .map(
              (item) => {
                'name': item.name,
                'isChronicle': item.isChronicle,
              },
            )
            .toList()),
      );
      if (response.statusCode >= 400) {
        _diseases.remove(newDisease);
        return false;
      }
      return true;
    } catch (err) {
      throw err;
    }
  }
}
