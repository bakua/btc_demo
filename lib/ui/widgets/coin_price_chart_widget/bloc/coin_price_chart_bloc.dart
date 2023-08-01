import 'package:bloc/bloc.dart';
import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/data/enumerations.dart';
import 'package:fl_chart/fl_chart.dart';

part 'coin_price_chart_event.dart';

part 'coin_price_chart_state.dart';

class CoinPriceChartBloc extends Bloc<CoinPriceChartEvent, CoinPriceChartState> {
  final CoinGeckoApi coinGeckoApi;

  CoinPriceChartBloc(this.coinGeckoApi) : super(CoinPriceChartInitialState()) {
    on<LoadCoinPriceChartEvent>((event, emit) async {
      try {
        final marketChart = await coinGeckoApi.coins.getCoinMarketChart(
          id: event.coinId,
          vsCurrency: 'usd',
          days: 3,
          interval: CoinMarketChartInterval.hourly,
        );
        final List<({DateTime date, FlSpot spot})> spots = [];
        var minPrice = double.infinity;
        var maxPrice = 0.0;

        for (final (index, data) in marketChart.data.indexed) {
          final price = data.price ?? 0;

          if (price < minPrice) {
            minPrice = price;
          }

          if (price > maxPrice) {
            maxPrice = price;
          }

          spots.add((date: data.date, spot: FlSpot(index.toDouble(), price)));
        }

        if (maxPrice < minPrice) {
          maxPrice = minPrice;
        }

        emit(CoinPriceChartSuccessState(spots: spots, minPrice: minPrice, maxPrice: maxPrice));
      } catch (e) {
        emit(CoinPriceChartFailedState(e));
      }
    });
  }
}
