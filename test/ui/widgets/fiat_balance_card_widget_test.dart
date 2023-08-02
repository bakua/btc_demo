import 'package:btc_demo/lib/model/wallet.dart';
import 'package:btc_demo/ui/widgets/fiat_balance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final wallet = Wallet(btcBalance: 1234, usdBalance: 4567);

    await tester.pumpWidget(MaterialApp(home: FiatBalanceCardWidget(wallet: wallet)));

    expect(find.text('four thousand five hundred and sixty seven', findRichText: true), findsOneWidget);
  });
}
