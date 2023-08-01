part of 'home_bloc.dart';

sealed class HomeState {}

class HomeInitialState extends HomeState {}

class HomeSuccessState extends HomeState {
  final Wallet wallet;

  HomeSuccessState(this.wallet);
}

class HomeFailedState extends HomeState {
  final dynamic error;

  HomeFailedState(this.error);
}
