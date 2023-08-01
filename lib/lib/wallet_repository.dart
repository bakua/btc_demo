import 'package:btc_demo/lib/backend_api.dart';
import 'package:btc_demo/lib/model/wallet.dart';
import 'package:coingecko_api/coingecko_api.dart';

class WalletRepository {
  final BackendApi backendApi;
  final CoinGeckoApi coinGeckoApi;

  WalletRepository(this.backendApi, this.coinGeckoApi);

  Future<Wallet> getWallet() async {
    final walletBitcoinBalance = await backendApi.getBtcBalance();
    final geckoResponse = (await coinGeckoApi.simple.listPrices(ids: ['bitcoin'], vsCurrencies: ['usd'])).data;
    if (geckoResponse.isEmpty) {
      throw Exception('Failed to get bitcoin data.'); //todo use custom exception
    }

    final btcToUsdRate = geckoResponse.first.getPriceIn('usd');
    if (btcToUsdRate == null) {
      throw Exception('Failed to get bitcoin to usd rate.'); //todo use custom exception
    }

    return Wallet(btcBalance: walletBitcoinBalance, usdBalance: walletBitcoinBalance * btcToUsdRate);
  }
}
