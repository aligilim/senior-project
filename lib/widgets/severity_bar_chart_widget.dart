import 'package:covid_app/providers/operation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeverityBarChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<SeverityBarChartWidget> {
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
              maxY: dbItems.length * 1,
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
                        return 'Severe';
                      case 1:
                        return 'Moderate';
                      case 2:
                        return 'Mild';
                      case 3:
                        return 'None';
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
                                (item) => item.severitySevere,
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
                                (item) => item.severityModerate,
                              )
                              .length)
                          .toDouble(),
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.greenAccent,
                      ],
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      y: (dbItems
                              .where(
                                (item) => item.severityMild,
                              )
                              .length)
                          .toDouble(),
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.greenAccent,
                      ],
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 3,
                  barRods: [
                    BarChartRodData(
                      y: (dbItems
                              .where(
                                (item) => item.severityNone,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
