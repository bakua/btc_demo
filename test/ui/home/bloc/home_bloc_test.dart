import 'package:bloc_test/bloc_test.dart';
import 'package:btc_demo/lib/coins_price_repository.dart';
import 'package:btc_demo/lib/model/wallet.dart';
import 'package:btc_demo/lib/wallet_repository.dart';
import 'package:btc_demo/ui/home/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([
  WalletRepository,
  CoinsPriceRepository,
])
void main() {
  group('HomeBloc', () {
    late MockWalletRepository mockWalletRepository;
    late MockCoinsPriceRepository mockCoinsPriceRepository;
    late HomeBloc homeBloc;

    setUp(() {
      mockWalletRepository = MockWalletRepository();
      mockCoinsPriceRepository = MockCoinsPriceRepository();
      homeBloc = HomeBloc(mockWalletRepository, mockCoinsPriceRepository);
    });

    group('When LoadHomeEvent succeeds', () {
      setUp(() {
        when(mockWalletRepository.getWallet()).thenAnswer((_) async => const Wallet(btcBalance: 2.25, usdBalance: 50000.0));
        when(mockCoinsPriceRepository.getBtcToUsdPrice()).thenAnswer((_) async => 50000.0);
      });

      blocTest<HomeBloc, HomeState>(
        'Then emits [HomeSuccessState].',
        build: () => homeBloc,
        act: (bloc) => bloc.add(LoadHomeEvent()),
        expect: () => [
          HomeSuccessState(wallet: const Wallet(btcBalance: 2.25, usdBalance: 50000.0), btcToUsdPrice: 50000.0),
        ],
      );
    });

    group('When LoadHomeEvent fails.', () {
      setUp(() {
        when(mockWalletRepository.getWallet()).thenThrow(Exception('Failed to get wallet.'));
      });

      blocTest<HomeBloc, HomeState>(
        'Then emits [HomeFailedState].',
        build: () => homeBloc,
        act: (bloc) => bloc.add(LoadHomeEvent()),
        expect: () => [
          isA<HomeFailedState>(),
        ],
      );
    });
  });
}
