import 'package:covid_app/providers/operation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VaccineBarChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<VaccineBarChartWidget> {
  List<String> vaccineList = [
    'BionTech',
    'Sinovac',
    'Sputnik',
    'AstraZeneca',
    'Johnson\n-Johnson',
    'Sinopharm'
  ];
  @override
  Widget build(BuildContext context) {
    final patients = Provider.of<Operation>(context).patients;
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
              maxY: patients.length * 0.8,
              barTouchData: BarTouchData(
                enabled: false,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  tooltipPadding: const EdgeInsets.all(0),
                  tooltipMargin: 8,
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
                    color: Color(0xff7589a2),
                    fontSize: 12,
                  ),
                  margin: 20,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return vaccineList[0];
                      case 1:
                        return vaccineList[1];
                      case 2:
                        return vaccineList[2];
                      case 3:
                        return vaccineList[3];
                      case 4:
                        return vaccineList[4];
                      case 5:
                        return vaccineList[5];
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
                        y: (patients
                                .where(
                                  (el) => !el.vaccinated
                                      ? false
                                      : el.vaccineData!.vaccineType ==
                                          'BionTech',
                                )
                                .length)
                            .toDouble(),
                        colors: [Colors.lightBlueAccent, Colors.greenAccent])
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                        y: (patients
                                .where(
                                  (el) => !el.vaccinated
                                      ? false
                                      : el.vaccineData!.vaccineType ==
                                          'Sinovac',
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
                        y: (patients
                                .where((el) => !el.vaccinated
                                    ? false
                                    : el.vaccineData!.vaccineType == 'Sputnik')
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
                        y: (patients
                                .where((el) => !el.vaccinated
                                    ? false
                                    : el.vaccineData!.vaccineType ==
                                        'AstraZeneca')
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
                        y: (patients
                                .where((el) => !el.vaccinated
                                    ? false
                                    : el.vaccineData!.vaccineType ==
                                        'Johnson-Johnson')
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
                        y: (patients
                                .where((el) => !el.vaccinated
                                    ? false
                                    : el.vaccineData!.vaccineType ==
                                        'Sinopharm')
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
