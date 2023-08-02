import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final double btcBalance;
  final double usdBalance;

  const Wallet({required this.btcBalance, required this.usdBalance});

  @override
  List<Object?> get props => [btcBalance, usdBalance];
}
