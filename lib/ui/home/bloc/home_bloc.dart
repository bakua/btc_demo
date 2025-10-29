import 'package:bloc/bloc.dart';
import 'package:btc_demo/lib/coins_price_repository.dart';
import 'package:btc_demo/lib/model/wallet.dart';
import 'package:btc_demo/lib/wallet_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WalletRepository walletRepository;
  final CoinsPriceRepository coinsPriceRepository;

  HomeBloc(
    this.walletRepository,
    this.coinsPriceRepository,
  ) : super(HomeInitialState()) {
    on<LoadHomeEvent>((event, emit) async {
      try {
        final wallet = await walletRepository.getWallet();
        final btcToUsdPrice = await coinsPriceRepository.getBtcToUsdPrice();

        emit(HomeSuccessState(wallet: wallet, btcToUsdPrice: btcToUsdPrice));
      } catch (e) {
        emit(HomeFailedState(e.toString()));
        // Here we can log the error to a crash reporting service.
      }
    });
  }
}
