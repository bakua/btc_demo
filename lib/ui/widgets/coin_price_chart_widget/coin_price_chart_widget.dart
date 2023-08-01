import 'package:btc_demo/lib/text.dart';
import 'package:btc_demo/service_locator.dart';
import 'package:btc_demo/ui/widgets/coin_price_chart_widget/bloc/coin_price_chart_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinPriceChartWidget extends StatelessWidget {
  final String coinId;

  const CoinPriceChartWidget({Key? key, required this.coinId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoinPriceChartBloc(inject())..add(LoadCoinPriceChartEvent(coinId)),
      child: BlocBuilder<CoinPriceChartBloc, CoinPriceChartState>(
        builder: (context, state) {
          final now = DateTime.now();
          final List<({DateTime date, FlSpot spot})> spots;
          final double minPrice, maxPrice;

          switch (state) {
            case CoinPriceChartInitialState():
            case CoinPriceChartFailedState():
              spots = List.generate(72, (index) => (date: now.subtract(Duration(hours: 71 - index)), spot: FlSpot(index.toDouble(), 100000)));
              minPrice = 0;
              maxPrice = 100000;
            case CoinPriceChartSuccessState():
              spots = state.spots;
              minPrice = state.minPrice;
              maxPrice = state.maxPrice;
          }

          final priceDiff = maxPrice - minPrice;

          return Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatCurrency(maxPrice, 'USD', symbol: '\$'), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      Text(formatCurrency((minPrice + maxPrice) / 2, 'USD', symbol: '\$'), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Text(formatCurrency(minPrice, 'USD', symbol: '\$'), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 164,
                child: LineChart(
                  duration: const Duration(milliseconds: 750),
                  curve: Curves.easeInOutExpo,
                  LineChartData(
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 12,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= spots.length) {
                              return const SizedBox.shrink();
                            }

                            final hoursAgo = now.difference(spots[index].date).inHours;

                            if (hoursAgo > 48) {
                              return const SizedBox.shrink();
                            }

                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 0,
                              child: Padding(
                                padding: EdgeInsets.only(right: hoursAgo > 0 ? 0 : 24),
                                child: Text(
                                  hoursAgo > 0 ? '${hoursAgo}h' : 'Now',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => const FlLine(color: Colors.white24, strokeWidth: 1, dashArray: [5, 10]),
                    ),
                    minX: 0,
                    maxX: spots.length.toDouble(),
                    minY: minPrice - priceDiff * .1,
                    maxY: maxPrice + priceDiff * .1,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots.map((e) => e.spot).toList(),
                        isCurved: true,
                        gradient:
                            const LinearGradient(colors: [Colors.white, Colors.white38, Colors.white], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                              colors: [Colors.orange.withOpacity(.3), Colors.white38, Colors.white70], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
