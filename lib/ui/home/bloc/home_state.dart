part of 'home_bloc.dart';

sealed class HomeState extends Equatable {}

class HomeInitialState extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeSuccessState extends HomeState {
  final Wallet wallet;
  final double btcToUsdPrice;

  HomeSuccessState({
    required this.wallet,
    required this.btcToUsdPrice,
  });

  @override
  List<Object?> get props => [wallet, btcToUsdPrice];

}

class HomeFailedState extends HomeState {
  final dynamic error;

  HomeFailedState(this.error);

  @override
  List<Object?> get props => [error];
}
