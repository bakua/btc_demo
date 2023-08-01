import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/data/enumerations.dart';
import 'package:coingecko_api/data/market_chart_data.dart';

//todo implement example test for this
class CoinsPriceRepository {
  final CoinGeckoApi coinGeckoApi;

  CoinsPriceRepository(this.coinGeckoApi);

  Future<double> getBtcToUsdPrice() async {
    final geckoResponse = (await coinGeckoApi.simple.listPrices(ids: ['bitcoin'], vsCurrencies: ['usd'])).data;
    if (geckoResponse.isEmpty) {
      throw Exception('Failed to get bitcoin data.'); //todo use custom exception
    }

    final btcToUsdRate = geckoResponse.first.getPriceIn('usd');
    if (btcToUsdRate == null) {
      throw Exception('Failed to get bitcoin to usd rate.'); //todo use custom exception
    }

    return btcToUsdRate;
  }

  Future<List<MarketChartData>> getCoinToUsdPriceHistory({required String coinId, required int days}) async {
    final marketChart = await coinGeckoApi.coins.getCoinMarketChart(
      id: coinId,
      vsCurrency: 'usd',
      days: days,
      interval: CoinMarketChartInterval.hourly,
    );

    return marketChart.data;
  }
}