import 'package:covid_app/providers/operation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SymptomsDayChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<SymptomsDayChartWidget> {
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
    final symptomsOfDay = Provider.of<Operation>(context).symptomsOfDay;
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
