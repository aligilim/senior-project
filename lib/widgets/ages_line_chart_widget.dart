import 'package:covid_app/providers/operation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgesLineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final patients = Provider.of<Operation>(context).patients;
    final agesList = patients.where((el) => el.age != null).toList();
    const cutOffYValue = 5.0;
    const dateTextStyle = TextStyle(
      fontSize: 10,
      color: Colors.purple,
      fontWeight: FontWeight.bold,
    );

    return SizedBox(
      width: 350,
      height: 180,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(
                  0,
                  agesList
                      .where((el) => double.parse(el.age!) <= 10)
                      .length
                      .toDouble(),
                ),
                FlSpot(
                  1,
                  agesList
                      .where(
                        (el) =>
                            double.parse(el.age!) <= 20 &&
                            double.parse(el.age!) > 10,
                      )
                      .length
                      .toDouble(),
                ),
                FlSpot(
                  2,
                  agesList
                      .where(
                        (el) =>
                            double.parse(el.age!) <= 30 &&
                            double.parse(el.age!) > 20,
                      )
                      .length
                      .toDouble(),
                ),
                FlSpot(
                  3,
                  agesList
                      .where((el) =>
                          double.parse(el.age!) <= 40 &&
                          double.parse(el.age!) > 30)
                      .length
                      .toDouble(),
                ),
                FlSpot(
                  4,
                  agesList
                      .where((el) =>
                          double.parse(el.age!) <= 50 &&
                          double.parse(el.age!) > 40)
                      .length
                      .toDouble(),
                ),
                FlSpot(
                  5,
                  agesList
                      .where((el) =>
                          double.parse(el.age!) <= 60 &&
                          double.parse(el.age!) > 50)
                      .length
                      .toDouble(),
                ),
                FlSpot(
                  6,
                  agesList
                      .where((el) =>
                          double.parse(el.age!) <= 70 &&
                          double.parse(el.age!) > 60)
                      .length
                      .toDouble(),
                ),
                FlSpot(
                  7,
                  agesList
                      .where((el) =>
                          double.parse(el.age!) <= 80 &&
                          double.parse(el.age!) > 70)
                      .length
                      .toDouble(),
                ),
                FlSpot(
                  8,
                  agesList
                      .where((el) =>
                          double.parse(el.age!) <= 90 &&
                          double.parse(el.age!) > 80)
                      .length
                      .toDouble(),
                ),
                FlSpot(
                  9,
                  agesList
                      .where((el) =>
                          double.parse(el.age!) <= 100 &&
                          double.parse(el.age!) > 90)
                      .length
                      .toDouble(),
                ),
              ],
              isCurved: true,
              barWidth: 2,
              colors: [
                Colors.purpleAccent,
              ],
              belowBarData: BarAreaData(
                show: true,
                colors: [Colors.orange.withOpacity(0.6)],
                // colors: [Colors.deepPurple.withOpacity(0.4)],
                cutOffY: cutOffYValue,
                applyCutOffY: true,
              ),
              // aboveBarData: BarAreaData(
              //   show: true,
              //   colors: [Colors.orange.withOpacity(0.6)],
              //   cutOffY: cutOffYValue,
              //   applyCutOffY: true,
              // ),
              dotData: FlDotData(
                show: false,
              ),
            ),
          ],
          minY: 0,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 14,
                getTextStyles: (value) => dateTextStyle,
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return '0';
                    case 1:
                      return '10';
                    case 2:
                      return '20';
                    case 3:
                      return '30';
                    case 4:
                      return '40';
                    case 5:
                      return '50';
                    case 6:
                      return '60';
                    case 7:
                      return '70';
                    case 8:
                      return '80';
                    case 9:
                      return '90';
                    case 10:
                      return '100';
                    default:
                      return '';
                  }
                }),
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                return '${value.toInt()}';
              },
            ),
          ),
          axisTitleData: FlAxisTitleData(
            leftTitle: AxisTitle(
              showTitle: true,
              titleText: 'No. patients',
              margin: 0,
            ),
            bottomTitle: AxisTitle(
              showTitle: true,
              margin: 0,
              titleText: 'Age',
              textStyle: dateTextStyle,
            ),
          ),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (double value) {
              return true;
            },
          ),
        ),
      ),
    );
  }
}
