import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/data/market_chart_data.dart';

class CoinsPriceRepository {
  final CoinGeckoApi coinGeckoApi;

  CoinsPriceRepository(this.coinGeckoApi);

  //The coingecko API has a rate limit. It was constantly breaking the app when running tests, and displaying an error in the app.
  //I had to work around it by "fixing" this "bug".
  Future<double> getBtcToUsdPrice() async {
    const maxRetries = 50;
    for (var i = 0; i < maxRetries; i++) {
      try {
        print('Attempt #${i + 1} to fetch BTC price...');
        final result = await coinGeckoApi.simple.listPrices(ids: ['bitcoin'], vsCurrencies: ['usd']);

        // First, check if the API call itself resulted in an error.
        if (result.isError) {
          throw Exception('CoinGecko API error: ${result.errorMessage}');
        }

        final geckoResponse = result.data;
        print('  - API Response: $geckoResponse');

        final btcToUsdRate = geckoResponse.isNotEmpty ? geckoResponse.first.getPriceIn('usd') : null;
        print('  - Extracted Rate: $btcToUsdRate');

        if (btcToUsdRate == null) {
          print('  - Rate is null, throwing exception.');
          throw Exception('Failed to get bitcoin to usd rate from response.');
        }

        print('Success! Returning price: $btcToUsdRate');
        return btcToUsdRate;
      } catch (e) {
        print('  - Caught Exception on attempt #${i + 1}: $e');
        if (i == maxRetries - 1) {
          print('Max retries reached. Rethrowing exception.');
          rethrow;
        }
        print('  - Rate limited. Waiting 10 seconds before next retry...');
        await Future.delayed(const Duration(seconds: 10));
      }
    }
    throw Exception('Failed to fetch price after multiple retries.');
  }

  Future<List<MarketChartData>> getCoinToUsdPriceHistory({required String coinId, required int days}) async {
    final marketChart = await coinGeckoApi.coins.getCoinMarketChart(id: coinId, vsCurrency: 'usd', days: days);

    if (marketChart.isError) {
      throw Exception('${marketChart.errorCode} ${marketChart.errorMessage}');
    }

    return marketChart.data;
  }
}
