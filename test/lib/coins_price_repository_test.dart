import 'package:btc_demo/lib/coins_price_repository.dart';
import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/coingecko_result.dart';
import 'package:coingecko_api/data/market_chart_data.dart';
import 'package:coingecko_api/data/price_info.dart';
import 'package:coingecko_api/sections/coins_section.dart';
import 'package:coingecko_api/sections/simple_section.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'coins_price_repository_test.mocks.dart';

@GenerateMocks([
  CoinGeckoApi,
  SimpleSection,
  CoinsSection,
])
void main() {
  group('CoinsPriceRepository', () {
    late CoinsPriceRepository coinsPriceRepository;
    late MockCoinGeckoApi mockCoinGeckoApi;
    late MockSimpleSection mockSimpleSection;
    late MockCoinsSection mockCoinsSection;

    setUp(() {
      mockCoinGeckoApi = MockCoinGeckoApi();
      mockSimpleSection = MockSimpleSection();
      mockCoinsSection = MockCoinsSection();

      when(mockCoinGeckoApi.simple).thenReturn(mockSimpleSection);
      when(mockCoinGeckoApi.coins).thenReturn(mockCoinsSection);

      coinsPriceRepository = CoinsPriceRepository(mockCoinGeckoApi);
    });

    group('getBtcToUsdPrice', () {
      group('When succeeds.', () {
        setUp(() {
          when(mockSimpleSection.listPrices(ids: ['bitcoin'], vsCurrencies: ['usd'])).thenAnswer(
            (_) async => CoinGeckoResult([
              PriceInfo.fromJson('bitcoin', {'usd': 50000.0})
            ]),
          );
        });

        test('Then should return btc to usd price.', () async {
          final price = await coinsPriceRepository.getBtcToUsdPrice();

          verify(mockSimpleSection.listPrices(ids: ['bitcoin'], vsCurrencies: ['usd'])).called(1);
          expect(price, 50000.0);
        });
      });

      group('When api returns empty data.', () {
        setUp(() {
          when(mockSimpleSection.listPrices(ids: ['bitcoin'], vsCurrencies: ['usd'])).thenAnswer(
            (_) async => CoinGeckoResult([]),
          );
        });

        test('Then should throw exception.', () async {
          expect(
              coinsPriceRepository.getBtcToUsdPrice(), throwsA(predicate((e) => e is Exception && e.toString() == 'Exception: Failed to get bitcoin data.')));
        });
      });

      group('When api does not return usd price.', () {
        setUp(() {
          when(mockSimpleSection.listPrices(ids: ['bitcoin'], vsCurrencies: ['usd'])).thenAnswer(
            (_) async => CoinGeckoResult([
              PriceInfo.fromJson('bitcoin', {'eur': 50000.0})
            ]),
          );
        });

        test('Then should throw exception.', () async {
          expect(coinsPriceRepository.getBtcToUsdPrice(),
              throwsA(predicate((e) => e is Exception && e.toString() == 'Exception: Failed to get bitcoin to usd rate.')));
        });
      });
    });

    group('getCoinToUsdPriceHistory', () {
      group('When succeeds.', () {
        setUp(() {
          when(mockCoinsSection.getCoinMarketChart(id: 'bitcoin', vsCurrency: 'usd', days: 30))
              .thenAnswer((_) async => CoinGeckoResult([MarketChartData(DateTime.now())]));
        });

        test('Then should return coin to usd price history.', () async {
          final marketChartData = await coinsPriceRepository.getCoinToUsdPriceHistory(coinId: 'bitcoin', days: 30);

          verify(mockCoinsSection.getCoinMarketChart(id: 'bitcoin', vsCurrency: 'usd', days: 30)).called(1);
          expect(marketChartData.isEmpty, false);
        });
      });

      group('When api returns error.', () {
        setUp(() {
          when(mockCoinsSection.getCoinMarketChart(id: 'bitcoin', vsCurrency: 'usd', days: 30))
              .thenAnswer((_) async => CoinGeckoResult([], isError: true, errorCode: 500, errorMessage: 'Internal server error.'));
        });

        test('Then should throw exception.', () async {
          expect(coinsPriceRepository.getCoinToUsdPriceHistory(coinId: 'bitcoin', days: 30),
              throwsA(predicate((e) => e is Exception && e.toString() == 'Exception: 500 Internal server error.')));
        });
      });
    });
  });
}
