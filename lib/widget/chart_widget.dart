import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  ChartWidget({
    Key? key,
    required this.firstDataSection,
    required this.secondDataSection,
    required this.icon,
    required this.free,
    required this.total,
  }) : super(key: key);
  final PieChartSectionData firstDataSection;
  final PieChartSectionData secondDataSection;
  final IconData icon;
  final String free;
  final String total;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 70,
                startDegreeOffset: -90,
                sections: [
                  firstDataSection,
                  secondDataSection,
                ],
              ),
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    free.toString(),
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 0.4,
                        ),
                  ),
                  Text(
                    'of ' + total.toString(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
