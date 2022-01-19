import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample1 extends StatefulWidget {
  const PieChartSample1({Key? key, required this.expenseTypesTotal}) : super(key: key);

  final Map<String, double> expenseTypesTotal;

  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State<PieChartSample1> {
  int touchedIndex = -1;

  final List<Color> colors = [
    Color(0xff90be6d).withOpacity(0.8),
    Color(0xfff9c74f).withOpacity(0.8),
    Color(0xff845bef).withOpacity(0.8),
    Color(0xfff9844a).withOpacity(0.8),
    Color(0xfff94144).withOpacity(0.8),
    Color(0xff03071e).withOpacity(0.4),
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ), Container(
                height: 40,
                child: Wrap(
                  runSpacing: 20,
                  direction: Axis.horizontal,
                  // mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  alignment: WrapAlignment.spaceEvenly,
                  children:
                    createIndicators(widget.expenseTypesTotal),
                ),
              ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: widget.expenseTypesTotal.values.any((element) => element != 0.0) ? PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      startDegreeOffset: 180,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 7,
                      centerSpaceRadius: 35,
                      sections: showingSections(widget.expenseTypesTotal)),
                ) : Container(),
              ),
            ),
          ],
        ),
      );
  }

  List<Indicator> createIndicators(Map<String, double> expenseTypesTotal) {
    List<Indicator> returnList = [];

    int i = 0;
    for (final name in expenseTypesTotal.keys) {
      final ind = Indicator(
        color: colors[i].withOpacity(0.7),
        text: name,
        isSquare: false,
        size: touchedIndex == i ? 18 : 16,
        textColor: touchedIndex == i ? colors[i] : Colors.grey,
      );

      returnList.add(ind);
      i++;
    }

    return returnList;
  }

  List<PieChartSectionData> showingSections(Map<String, double> expenseTypesTotal) {
    List<PieChartSectionData> returnList = [];
    final double total = expenseTypesTotal.values.reduce((a, b) => a + b);

    int i = 0;
    for (final entry in expenseTypesTotal.entries) {
      final isTouched = i == touchedIndex;
      final opacity = isTouched ? 0.8 : 1.0;
      final PieChartSectionData pieChartSectionData = PieChartSectionData(
        color: colors[i],
        value: entry.value / total * 100,
        title: '',
        radius: 20,
        titleStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff044d7c)),
        titlePositionPercentageOffset: 0.55,
        borderSide: isTouched
            ? BorderSide(color: colors[i].darken(40), width: 6)
            : BorderSide(color: Colors.transparent),
      );

      returnList.add(pieChartSectionData);
      i++;
    }

    return returnList;

    return List.generate(
      4,
          (i) {
        final isTouched = i == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;

        const color0 = Color(0xff0293ee);
        const color1 = Color(0xfff8b250);
        const color2 = Color(0xff845bef);
        const color3 = Color(0xff13d38e);

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 65,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: color0.darken(40), width: 6)
                  : BorderSide(color: color0.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 65,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: color1.darken(40), width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: color2.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 60,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? BorderSide(color: color2.darken(40), width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: color3.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 70,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: color3.darken(40), width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: textColor),
        )
      ],
    );
  }
}

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(alpha, (red * value).round(), (green * value).round(),
        (blue * value).round());
  }
}