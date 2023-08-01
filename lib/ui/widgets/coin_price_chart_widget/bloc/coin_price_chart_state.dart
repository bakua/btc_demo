part of 'coin_price_chart_bloc.dart';

sealed class CoinPriceChartState {}

class CoinPriceChartInitialState extends CoinPriceChartState {}

class CoinPriceChartSuccessState extends CoinPriceChartState {
  final List<({DateTime date, FlSpot spot})> spots;
  final double minPrice;
  final double maxPrice;

  CoinPriceChartSuccessState({
    required this.spots,
    required this.minPrice,
    required this.maxPrice,
  });
}

class CoinPriceChartFailedState extends CoinPriceChartState {
  final dynamic error;

  CoinPriceChartFailedState(this.error);
}
