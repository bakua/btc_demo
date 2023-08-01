import 'package:btc_demo/lib/backend_api.dart';
import 'package:btc_demo/lib/wallet_repository.dart';
import 'package:coingecko_api/coingecko_api.dart';
import 'package:get_it/get_it.dart';

final inject = GetIt.instance;

Future<void> setUpInversionOfControl() async {
  inject.registerLazySingleton(() => BackendApi());
  inject.registerLazySingleton(() => CoinGeckoApi());
  inject.registerLazySingleton(() => WalletRepository(inject(), inject()));
}
