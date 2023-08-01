import 'package:bloc/bloc.dart';
import 'package:btc_demo/lib/model/wallet.dart';
import 'package:btc_demo/lib/wallet_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WalletRepository walletRepository;

  HomeBloc(this.walletRepository) : super(HomeInitialState()) {
    on<HomeLoadEvent>((event, emit) async {
      try {
        final wallet = await walletRepository.getWallet();
        emit(HomeSuccessState(wallet));
      } catch (e) {
        emit(HomeFailedState(e));
      }
    });
  }
}
