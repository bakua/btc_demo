part of 'coin_price_chart_bloc.dart';

sealed class CoinPriceChartEvent {}

class LoadCoinPriceChartEvent extends CoinPriceChartEvent {
  final String coinId;

  LoadCoinPriceChartEvent(this.coinId);
}

