import 'package:covid_app/providers/operation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SymptomsBarChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<SymptomsBarChartWidget> {
  @override
  Widget build(BuildContext context) {
    final dbItems = Provider.of<Operation>(context).filteredDbItems;
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
              maxY: dbItems.length * 1.3,
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
                        return 'Fever';
                      case 1:
                        return 'dry\ncough';
                      case 2:
                        return 'runny\nnose';
                      case 3:
                        return 'Breathing\ndifficulty';
                      case 4:
                        return 'Pains';
                      case 5:
                        return 'sore\nthroat';
                      case 6:
                        return 'tiredness';
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
                      y: (dbItems
                              .where(
                                (item) => item.fever,
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
                        y: (dbItems
                                .where(
                                  (item) => item.dryCough,
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
                        y: (dbItems
                                .where(
                                  (item) => item.runnyNose,
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
                        y: (dbItems
                                .where(
                                  (item) => item.difficultyInBreathing,
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
                        y: (dbItems
                                .where(
                                  (item) => item.pains,
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
                        y: (dbItems
                                .where(
                                  (item) => item.soreThroat,
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
                        y: (dbItems
                                .where(
                                  (item) => item.tiredness,
                                )
                                .length)
                            .toDouble(),
                        colors: [Colors.lightBlueAccent, Colors.greenAccent])
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 7,
                  barRods: [
                    BarChartRodData(
                        y: (dbItems
                                .where(
                                  (item) => item.noneSympton,
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
