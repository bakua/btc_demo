part of 'coin_price_chart_bloc.dart';

sealed class CoinPriceChartState extends Equatable {}

class CoinPriceChartInitialState extends CoinPriceChartState {
  @override
  List<Object?> get props => [];
}

class CoinPriceChartSuccessState extends CoinPriceChartState {
  final List<({DateTime date, FlSpot spot})> spots;
  final double minPrice;
  final double maxPrice;

  CoinPriceChartSuccessState({
    required this.spots,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  List<Object?> get props => [spots, minPrice, maxPrice];
}

class CoinPriceChartFailedState extends CoinPriceChartState {
  final dynamic error;

  CoinPriceChartFailedState(this.error);

  @override
  List<Object?> get props => [error];
}
