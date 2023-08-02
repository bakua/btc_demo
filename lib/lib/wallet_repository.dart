import 'package:btc_demo/lib/backend_api.dart';
import 'package:btc_demo/lib/coins_price_repository.dart';
import 'package:btc_demo/lib/model/wallet.dart';

class WalletRepository {
  final BackendApi backendApi;
  final CoinsPriceRepository coinsPriceRepository;

  WalletRepository(this.backendApi, this.coinsPriceRepository);

  Future<Wallet> getWallet() async {
    final walletBitcoinBalance = await backendApi.getBtcBalance();
    final btcToUsdRate = await coinsPriceRepository.getBtcToUsdPrice();

    return Wallet(btcBalance: walletBitcoinBalance, usdBalance: walletBitcoinBalance * btcToUsdRate);
  }
}
