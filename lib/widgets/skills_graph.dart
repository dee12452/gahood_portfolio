import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gahood_portfolio/widgets/description_text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SkillsGraph extends StatelessWidget {
  const SkillsGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const DescriptionText(
            text: 'Programming Languages',
            fontSize: 22,
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: 500,
              width: 800,
              child: BarChart(
                BarChartData(
                  backgroundColor: Colors.black12,
                  maxY: 10,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(toY: 9, color: Colors.red),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(toY: 7, color: Colors.green),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(toY: 6, color: Colors.orange),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(toY: 6, color: Colors.blue),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(toY: 4, color: Colors.yellow),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 5,
                      barRods: [
                        BarChartRodData(toY: 3, color: Colors.blue.shade200),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (idx, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          String text;
                          switch (idx.toInt()) {
                            case 0:
                              text = 'Java';
                              break;
                            case 1:
                              text = 'Python';
                              break;
                            case 2:
                              text = 'TypeScript';
                              break;
                            case 3:
                              text = 'Dart';
                              break;
                            case 4:
                              text = 'JavaScript';
                              break;
                            case 5:
                              text = 'Golang';
                              break;
                            default:
                              text = '';
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                swapAnimationDuration: const Duration(milliseconds: 200),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const DescriptionText(
            text: 'Tools and Frameworks',
            fontSize: 22,
          ),
          const SizedBox(
            height: 20,
          ),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ToolPercentIndicator(tool: 'Spring Boot', percent: .75),
                SizedBox(width: 10),
                _ToolPercentIndicator(tool: 'Flutter', percent: .65),
                SizedBox(width: 10),
                _ToolPercentIndicator(tool: 'Node.js', percent: .6),
                SizedBox(width: 10),
                _ToolPercentIndicator(tool: 'Docker', percent: .6),
                SizedBox(width: 10),
                _ToolPercentIndicator(tool: 'Django', percent: .55),
                SizedBox(width: 10),
                _ToolPercentIndicator(tool: 'SQL', percent: .45),
                SizedBox(width: 10),
                _ToolPercentIndicator(tool: 'NoSQL', percent: .4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolPercentIndicator extends StatelessWidget {
  final String tool;
  final double percent;

  const _ToolPercentIndicator({
    super.key,
    required this.tool,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 8.0,
          percent: percent,
          center: Text('${(percent * 100).toInt()}%'),
          progressColor: Colors.green,
        ),
        DescriptionText(text: tool),
      ],
    );
  }
}
