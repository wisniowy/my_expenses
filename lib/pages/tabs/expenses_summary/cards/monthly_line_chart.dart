import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartExample extends StatelessWidget {
  const LineChartExample({required this.isShowingMainData, required this.monthlyData});

  final bool isShowingMainData;
  final List<double> monthlyData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Padding(
      padding: const EdgeInsets.only(
      right: 10.0, left: 0, top: 25, bottom: 5),
          child: LineChart(sampleData2(monthlyData),
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        )
      );
  }


  LineChartData sampleData2(List<double> intSpots) => LineChartData(
    lineTouchData: lineTouchData2,
    gridData: gridData,
    titlesData: getTitlesData2(getTicks(intSpots.reduce(max).toInt())),
    borderData: borderData,
    lineBarsData: [lineChartBarData2_1(spots: intListToFlSpot(intSpots))],
    minX: 1,
    maxX: 13,
    maxY: intSpots.reduce(max) == 0 ? 100 : intSpots.reduce(max),
    minY: 0,
  );

  LineTouchData get lineTouchData2 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.black12.withOpacity(0.2),
    ),
  );



  FlTitlesData getTitlesData2(List<int> ticks) => FlTitlesData(
    bottomTitles: bottomTitles,
    rightTitles: SideTitles(showTitles: false),
    topTitles: SideTitles(showTitles: false),
    leftTitles: leftTitles(
      getTitles: (value) {
        if (ticks.contains(value.toInt())) {
          return value.toInt().toString();
        }
        return '';
      },
    ),
  );


  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
    getTitles: getTitles,
    showTitles: true,
    margin: 8,
    interval: 1,
    reservedSize: 40,
    getTextStyles: (context, value) =>  TextStyle(
      color: Colors.grey.withOpacity(0.4),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    ),
  );

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 22,
    margin: 10,
    interval: 1,
    getTextStyles: (context, value) => TextStyle(
      color: Colors.grey.withOpacity(0.4),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    getTitles: (value) {
      switch (value.toInt()) {
        case 1:
          return 'I';
        case 2:
          return 'II';
        case 3:
          return 'III';
        case 4:
          return 'IV';
        case 5:
          return 'V';
        case 6:
          return 'VI';
        case 7:
          return 'VII';
        case 8:
          return 'VIII';
        case 9:
          return 'IX';
        case 10:
          return 'X';
        case 11:
          return 'XI';
        case 12:
          return 'XII';
      }
      return '';
    },
  );

  FlGridData get gridData => FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white10.withOpacity(0.1),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.1),
          strokeWidth: 1,
        );
      });

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(color: Colors.black12.withOpacity(0.3), width: 2),
      left: BorderSide(color: Colors.transparent),
      right: BorderSide(color: Colors.transparent),
      top: BorderSide(color: Colors.transparent),
    ),
  );

  LineChartBarData lineChartBarData2_1({required List<FlSpot> spots}) => LineChartBarData(
    isCurved: true,
    curveSmoothness: 0,
    colors:  [Color(0xffFF9169).withOpacity(0.5 )],
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: spots,
  );

  List<FlSpot> intListToFlSpot(List<double> spots) {
    List<FlSpot> flSpots = [];
    for(int i = 0; i < spots.length; i++) {
      final double month = i + 1;
      flSpots.add(FlSpot(month, spots[i]));
    }
    return flSpots;
  }

  List<int> getTicks(int maxValue) {
    int tickValue;
    if( maxValue < 100 ) {
      tickValue = 10;
    }
    else if( maxValue < 500 ) {
      tickValue = 50;
    }
    else if( maxValue < 1000 ) {
      tickValue = 100;
    }
    else if( maxValue < 1500 ) {
      tickValue = 150;
    } //
    else if( maxValue < 2000 ) {
      tickValue = 200;
    }
    else if( maxValue < 4000 ) {
      tickValue = 400;
    } else {
      tickValue = 500;
    }

    int length = maxValue == 0 ? 10 : (maxValue / tickValue).toInt();

    return List.generate(length, (index) => (index + 1) * tickValue);
  }
}
