import 'package:btc_demo/lib/backend_api.dart';
import 'package:btc_demo/lib/coins_price_repository.dart';
import 'package:btc_demo/lib/wallet_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'wallet_repository_test.mocks.dart';

@GenerateMocks([
  BackendApi,
  CoinsPriceRepository,
])
void main() {
  group('WalletRepository', () {
    late WalletRepository walletRepository;
    late MockBackendApi backendApi;
    late MockCoinsPriceRepository coinsPriceRepository;

    setUp(() {
      backendApi = MockBackendApi();
      coinsPriceRepository = MockCoinsPriceRepository();
      walletRepository = WalletRepository(backendApi, coinsPriceRepository);
    });

    group('getWallet', () {
      group('When succeeds.', () {
        setUp(() {
          when(backendApi.getBtcBalance()).thenAnswer((_) => Future.value(2.25));
          when(coinsPriceRepository.getBtcToUsdPrice()).thenAnswer((_) => Future.value(2));
        });

        test('Then should return btc balance from backend.', () async {
          final wallet = await walletRepository.getWallet();

          verify(backendApi.getBtcBalance()).called(1);
          expect(wallet.btcBalance, 2.25);
        });

        test('Then should return usd balance based on current rate.', () async {
          final wallet = await walletRepository.getWallet();

          verify(coinsPriceRepository.getBtcToUsdPrice()).called(1);
          expect(wallet.usdBalance, 4.5);
        });
      });

      group('When fails to get btc balance from backend.', () {
        setUp(() {
          when(backendApi.getBtcBalance()).thenThrow(Exception('Backend error'));
        });

        test('Then should propagate exception.', () async {
          expect(walletRepository.getWallet(), throwsA(predicate((e) => e is Exception && e.toString() == 'Exception: Backend error')));
        });
      });

      group('When fails to get btc to usd rate.', () {
        setUp(() {
          when(backendApi.getBtcBalance()).thenAnswer((_) => Future.value(2.25));
          when(coinsPriceRepository.getBtcToUsdPrice()).thenThrow(Exception('Coins price error'));
        });

        test('Then should propagate exception.', () async {
          expect(walletRepository.getWallet(), throwsA(predicate((e) => e is Exception && e.toString() == 'Exception: Coins price error')));
        });
      });
    });
  });
}
