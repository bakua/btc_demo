import 'package:btc_demo/lib/model/wallet.dart';
import 'package:btc_demo/lib/text.dart';
import 'package:flutter/material.dart';

class BitcoinBalanceWidget extends StatelessWidget {
  final Wallet wallet;
  final double btcToUsdPrice;

  const BitcoinBalanceWidget({
    super.key,
    required this.wallet,
    required this.btcToUsdPrice,
  });

  @override
  Widget build(BuildContext context) {
    final wholeBtcAmount = wallet.btcBalance.floor();
    final fractionalBtcAmount = wallet.btcBalance - wholeBtcAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        const Text('Bitcoin', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: wholeBtcAmount.toString()),
              TextSpan(text: fractionalBtcAmount.toStringAsFixed(2).substring(1), style: const TextStyle(color: Colors.white70)),
              const WidgetSpan(child: SizedBox(width: 8)),
              const TextSpan(text: 'BTC', style: TextStyle(fontSize: 32, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        Text('(1 BTC = ${formatUSD(btcToUsdPrice)})', style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
