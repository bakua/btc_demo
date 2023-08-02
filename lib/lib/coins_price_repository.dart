import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/data/market_chart_data.dart';

class CoinsPriceRepository {
  final CoinGeckoApi coinGeckoApi;

  CoinsPriceRepository(this.coinGeckoApi);

  Future<double> getBtcToUsdPrice() async {
    final geckoResponse = (await coinGeckoApi.simple.listPrices(ids: ['bitcoin'], vsCurrencies: ['usd'])).data;
    if (geckoResponse.isEmpty) {
      // This would be some custom exception that you can properly handle.
      throw Exception('Failed to get bitcoin data.');
    }

    final btcToUsdRate = geckoResponse.first.getPriceIn('usd');
    if (btcToUsdRate == null) {
      throw Exception('Failed to get bitcoin to usd rate.');
    }

    return btcToUsdRate;
  }

  Future<List<MarketChartData>> getCoinToUsdPriceHistory({required String coinId, required int days}) async {
    final marketChart = await coinGeckoApi.coins.getCoinMarketChart(id: coinId, vsCurrency: 'usd', days: days);

    if (marketChart.isError) {
      throw Exception('${marketChart.errorCode} ${marketChart.errorMessage}');
    }

    return marketChart.data;
  }
}
