import 'package:btc_demo/lib/model/wallet.dart';
import 'package:btc_demo/lib/text.dart';
import 'package:flutter/material.dart';
import 'package:number_to_text_converter/number_to_text_converter.dart';

class FiatBalanceCardWidget extends StatelessWidget {
  final Wallet wallet;

  final converter = NumberToTextConverter.forInternationalNumberingSystem();

  FiatBalanceCardWidget({
    super.key,
    required this.wallet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textNumber = converter.convert(wallet.usdBalance.toInt());
    final lines = textNumber.split(' ');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Fiat balance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryColor)),
                  const SizedBox(height: 8),
                  Text(formatUSD(wallet.usdBalance), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87)),
                  RichText(
                    text: TextSpan(
                      children: [
                        for (final (index, line) in lines.indexed)
                          TextSpan(
                            text: index == 0 ? line : ' $line',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: index % 2 == 0 ? Colors.black54 : Colors.black38,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Withdraw', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
