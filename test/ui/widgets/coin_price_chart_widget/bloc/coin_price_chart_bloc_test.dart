import 'package:bloc_test/bloc_test.dart';
import 'package:btc_demo/lib/coins_price_repository.dart';
import 'package:btc_demo/ui/widgets/coin_price_chart_widget/bloc/coin_price_chart_bloc.dart';
import 'package:coingecko_api/data/market_chart_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'coin_price_chart_bloc_test.mocks.dart';

@GenerateMocks([
  CoinsPriceRepository,
])
void main() {
  group('CoinPriceChartBloc', () {
    late MockCoinsPriceRepository mockCoinsPriceRepository;
    late CoinPriceChartBloc coinPriceChartBloc;

    setUp(() {
      mockCoinsPriceRepository = MockCoinsPriceRepository();
      coinPriceChartBloc = CoinPriceChartBloc(mockCoinsPriceRepository);
    });

    group('When LoadCoinPriceChartEvent succeeds.', () {
      setUp(() {
        when(mockCoinsPriceRepository.getCoinToUsdPriceHistory(coinId: 'bitcoin', days: 3)).thenAnswer((_) async => [
              MarketChartData(DateTime(2023, 7, 6, 12, 13, 14), price: 40000.0),
              MarketChartData(DateTime(2023, 7, 6, 12, 14, 14), price: 50000.0),
              MarketChartData(DateTime(2023, 7, 6, 15, 13, 14), price: 60000.0),
            ]);
      });

      blocTest<CoinPriceChartBloc, CoinPriceChartState>(
        'Then emits [CoinPriceChartSuccessState]',
        build: () => coinPriceChartBloc,
        act: (bloc) => bloc.add(LoadCoinPriceChartEvent('bitcoin')),
        expect: () => [
          CoinPriceChartSuccessState(
            spots: [
              (date: DateTime(2023, 7, 6, 12, 13, 14), spot: const FlSpot(0, 40000.0)),
              (date: DateTime(2023, 7, 6, 12, 14, 14), spot: const FlSpot(1, 50000.0)),
              (date: DateTime(2023, 7, 6, 15, 13, 14), spot: const FlSpot(2, 60000.0)),
            ],
            minPrice: 40000.0,
            maxPrice: 60000.0,
          ),
        ],
      );
    });

    group('When coin history is empty.', () {
      setUp(() {
        when(mockCoinsPriceRepository.getCoinToUsdPriceHistory(coinId: 'bitcoin', days: 3)).thenAnswer((_) async => []);
      });

      blocTest<CoinPriceChartBloc, CoinPriceChartState>(
        'Then emits min and max price as 0',
        build: () => coinPriceChartBloc,
        act: (bloc) => bloc.add(LoadCoinPriceChartEvent('bitcoin')),
        expect: () => [
          CoinPriceChartSuccessState(
            spots: const [],
            minPrice: 0,
            maxPrice: 0,
          ),
        ],
      );
    });

    group('When LoadCoinPriceChartEvent fails.', () {
      setUp(() {
        when(mockCoinsPriceRepository.getCoinToUsdPriceHistory(coinId: 'bitcoin', days: 3)).thenThrow(Exception('Failed to get coin price history.'));
      });

      blocTest<CoinPriceChartBloc, CoinPriceChartState>(
        'Then emits [CoinPriceChartFailedState].',
        build: () => coinPriceChartBloc,
        act: (bloc) => bloc.add(LoadCoinPriceChartEvent('bitcoin')),
        expect: () => [
          isA<CoinPriceChartFailedState>(),
        ],
      );
    });
  });
}
