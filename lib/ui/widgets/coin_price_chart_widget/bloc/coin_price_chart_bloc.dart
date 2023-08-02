import 'package:bloc/bloc.dart';
import 'package:btc_demo/lib/coins_price_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

part 'coin_price_chart_event.dart';

part 'coin_price_chart_state.dart';

class CoinPriceChartBloc extends Bloc<CoinPriceChartEvent, CoinPriceChartState> {
  final CoinsPriceRepository coinsPriceRepository;

  CoinPriceChartBloc(this.coinsPriceRepository) : super(CoinPriceChartInitialState()) {
    on<LoadCoinPriceChartEvent>((event, emit) async {
      try {
        final List<({DateTime date, FlSpot spot})> spots = [];
        var minPrice = double.infinity;
        var maxPrice = 0.0;

        final coinPriceHistory = await coinsPriceRepository.getCoinToUsdPriceHistory(coinId: event.coinId, days: 3);
        for (final (index, data) in coinPriceHistory.indexed) {
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
          minPrice = maxPrice;
        }

        emit(CoinPriceChartSuccessState(spots: spots, minPrice: minPrice, maxPrice: maxPrice));
      } catch (e) {
        emit(CoinPriceChartFailedState(e));
        // Here we can log the error to a crash reporting service.
      }
    });
  }
}
