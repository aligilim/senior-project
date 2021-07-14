import 'package:covid_app/providers/operation.dart';
import 'package:covid_app/widgets/severity_bar_chart_widget.dart';
import 'package:covid_app/widgets/symptoms_bar_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminAnalysisScreen extends StatefulWidget {
  static const routeName = 'admin-analysis-screen';
  AdminAnalysisScreen({Key? key}) : super(key: key);

  @override
  _AdminAnalysisScreenState createState() => _AdminAnalysisScreenState();
}

class _AdminAnalysisScreenState extends State<AdminAnalysisScreen> {
  bool isInit = false;
  String selectedGender = 'All';
  List<String> genderList = [
    'All',
    'Female',
    'Male',
    'Other',
  ];
  String selectedAge = 'All';
  List<String> ageRanges = [
    'All',
    '0-9',
    '10-19',
    '20-24',
    '25-59',
    '60+',
  ];
  String selectedCountry = 'All';
  List<String> countries = [
    'All',
    'China',
    'Italy',
    'Iran',
    'Republic of Korean',
    'France',
    'Spain',
    'Germany',
    'UAE',
    'Other-EUR',
    'Other',
  ];
  @override
  void didChangeDependencies() {
    if (isInit) {
      // Provider.of<Operation>(context, listen: false)
      //     .fetchDatabaseItems()
      //     .then((value) {
      //   setState(() {
      //     isInit = false;
      //   });
      // });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final dbItems = Provider.of<Operation>(context).databaseItems;
    final filteredDbItems = Provider.of<Operation>(context).filteredDbItems;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Analysis Report'),
          bottom: TabBar(
            onTap: (index) {},
            tabs: [
              Tab(text: 'General Analysis'),
              Tab(text: 'Analyze by Day'),
            ],
          ),
        ),
        body: isInit
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 8.0),
                    const Text('Loading...'),
                  ],
                ),
              )
            : TabBarView(
                children: [
                  dbItems.length <= 0
                      ? Center(
                          child: Text('No Symptoms to show'),
                        )
                      : ListView(
                          padding:
                              EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                          children: [
                            Text(
                              'Filters:',
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Gender: '),
                                Container(
                                  padding: EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  height: 40,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration.collapsed(
                                      hintText: '',
                                    ),
                                    hint: Text('Select Gender'),
                                    value: selectedGender,
                                    items: genderList.map(
                                      (gender) {
                                        return DropdownMenuItem<String>(
                                          value: gender,
                                          child: Text(gender),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (gender) {
                                      setState(() {
                                        selectedGender = gender!;
                                      });
                                      Provider.of<Operation>(context,
                                              listen: false)
                                          .filterDbItems(
                                        selectedCountry,
                                        selectedAge,
                                        gender!,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Age Range: '),
                                Container(
                                  padding: EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  height: 40,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration.collapsed(
                                      hintText: '',
                                    ),
                                    hint: Text('Select Range'),
                                    value: selectedAge,
                                    items: ageRanges.map(
                                      (range) {
                                        return DropdownMenuItem<String>(
                                          value: range,
                                          child: Text(range),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (range) {
                                      setState(() {
                                        selectedAge = range!;
                                      });
                                      Provider.of<Operation>(context,
                                              listen: false)
                                          .filterDbItems(
                                        selectedCountry,
                                        range!,
                                        selectedGender,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Country: '),
                                Container(
                                  padding: EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  height: 40,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration.collapsed(
                                      hintText: '',
                                    ),
                                    hint: Text('Select Country'),
                                    value: selectedCountry,
                                    items: countries.map(
                                      (country) {
                                        return DropdownMenuItem<String>(
                                          value: country,
                                          child: Text(country),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (country) {
                                      setState(() {
                                        selectedCountry = country!;
                                      });
                                      Provider.of<Operation>(context,
                                              listen: false)
                                          .filterDbItems(
                                        country!,
                                        selectedAge,
                                        selectedGender,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text('Number of Samples:'),
                              trailing: Text(
                                  '${filteredDbItems.length} of ${dbItems.length}'),
                            ),
                            Text(
                              'Symptoms:',
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 12.0),
                            SymptomsBarChartWidget(),
                            Text(
                              'Severity:',
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 12.0),
                            SeverityBarChartWidget(),
                          ],
                        ),
                  AnalyzeByDayWidget(),
                ],
              ),
      ),
    );
  }
}

class AnalyzeByDayWidget extends StatefulWidget {
  AnalyzeByDayWidget({Key? key}) : super(key: key);

  @override
  _AnalyzeByDayWidgetState createState() => _AnalyzeByDayWidgetState();
}

class _AnalyzeByDayWidgetState extends State<AnalyzeByDayWidget> {
  bool isInit = true;
  String selectedDay = 'one';
  List<String> _days = [
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
  ];
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Operation>(context, listen: false)
          .getSQLSymptoms()
          .then((value) {
        setState(() {
          Provider.of<Operation>(context, listen: false)
              .filterSqlSymptomsByDay('one');
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isInit
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            children: [
              Text(
                'Filters:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Day: '),
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
                      hint: Text('Select Day'),
                      value: selectedDay,
                      items: _days.map(
                        (day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        },
                      ).toList(),
                      onChanged: (day) {
                        setState(() {
                          selectedDay = day!;
                        });
                        Provider.of<Operation>(context, listen: false)
                            .filterSqlSymptomsByDay(day!);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                'Symptoms of the Day',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 8.0),
              _SymptomsDayChartWidget(),
            ],
          );
  }
}

class _SymptomsDayChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<_SymptomsDayChartWidget> {
  List<String> _defaultSymptoms = [
    'Fever',
    'Dry Cough',
    'Mucus or Phlegm',
    'Shortness of breath',
    'Loss of appetite',
    'Body aches',
  ];
  @override
  Widget build(BuildContext context) {
    final symptomsOfDay = Provider.of<Operation>(context).sqlSymptomsOfDay;
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              groupsSpace: 8.0,
              maxY: symptomsOfDay.length * 1.3,
              barTouchData: BarTouchData(
                enabled: false,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  tooltipPadding: EdgeInsets.zero,
                  tooltipMargin: 4.0,
                  getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                  ) {
                    return BarTooltipItem(
                      rod.y.round().toString(),
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                  margin: 25,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return _defaultSymptoms[0];
                      case 1:
                        return 'Dry\nCough';
                      case 2:
                        return 'Mucus\nor Phlegm';
                      case 3:
                        return 'Shortness\nof breath';
                      case 4:
                        return 'Loss of\nappetite';
                      case 5:
                        return 'Body\naches';
                      case 6:
                        return 'Other';
                      case 7:
                        return 'none';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(showTitles: false),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      y: (symptomsOfDay
                              .where(
                                (item) => item.symptomsOfDay.contains(
                                  _defaultSymptoms[0],
                                ),
                              )
                              .length)
                          .toDouble(),
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.greenAccent,
                      ],
                    )
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                        y: (symptomsOfDay
                                .where(
                                  (item) => item.symptomsOfDay.contains(
                                    _defaultSymptoms[1],
                                  ),
                                )
                                .length)
                            .toDouble(),
                        colors: [Colors.lightBlueAccent, Colors.greenAccent])
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                        y: (symptomsOfDay
                                .where(
                                  (item) => item.symptomsOfDay.contains(
                                    _defaultSymptoms[2],
                                  ),
                                )
                                .length)
                            .toDouble(),
                        colors: [Colors.lightBlueAccent, Colors.greenAccent])
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 3,
                  barRods: [
                    BarChartRodData(
                        y: (symptomsOfDay
                                .where(
                                  (item) => item.symptomsOfDay.contains(
                                    _defaultSymptoms[3],
                                  ),
                                )
                                .length)
                            .toDouble(),
                        colors: [Colors.lightBlueAccent, Colors.greenAccent])
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 4,
                  barRods: [
                    BarChartRodData(
                        y: (symptomsOfDay
                                .where(
                                  (item) => item.symptomsOfDay.contains(
                                    _defaultSymptoms[4],
                                  ),
                                )
                                .length)
                            .toDouble(),
                        colors: [Colors.lightBlueAccent, Colors.greenAccent])
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 5,
                  barRods: [
                    BarChartRodData(
                        y: (symptomsOfDay
                                .where(
                                  (item) => item.symptomsOfDay.contains(
                                    _defaultSymptoms[5],
                                  ),
                                )
                                .length)
                            .toDouble(),
                        colors: [Colors.lightBlueAccent, Colors.greenAccent])
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 6,
                  barRods: [
                    BarChartRodData(
                        y: (symptomsOfDay.where(
                          (item) {
                            for (final sym in item.symptomsOfDay) {
                              if (!_defaultSymptoms.contains(sym) &&
                                  sym != 'No Symptoms') {
                                return true;
                              }
                            }
                            return false;
                          },
                        ).length)
                            .toDouble(),
                        colors: [Colors.lightBlueAccent, Colors.greenAccent])
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 7,
                  barRods: [
                    BarChartRodData(
                        y: (symptomsOfDay
                                .where(
                                  (item) => item.symptomsOfDay
                                      .contains('No Symptoms'),
                                )
                                .length)
                            .toDouble(),
                        colors: [Colors.lightBlueAccent, Colors.greenAccent])
                  ],
                  showingTooltipIndicators: [0],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
