import 'package:btc_demo/service_locator.dart';
import 'package:btc_demo/ui/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    //Ensure services are initialized before the test runs.
    await setUpInversionOfControl();
  });

  group('Wallet tests', () {
    testWidgets('should copy address and use it to edit wallet name', (tester) async {
      //Set up a mock handler for the clipboard.
      final List<String> clipboardLog = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            clipboardLog.add(methodCall.arguments['text']);
          }
          return null;
        },
      );

      await tester.pumpWidget(const AppWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('nav_wallet_icon')));
      await tester.pumpAndSettle();

      //Copy the address to the clipboard.
      await tester.tap(find.byIcon(Icons.copy));
      const address = '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa';
      await tester.tap(find.text(address));
      await tester.pumpAndSettle();
      expect(clipboardLog.first, address);

      //Edit the wallet name to the contents of the clipboard (proof it got stored in there)
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), clipboardLog.first);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text(address), findsNWidgets(2));

      //Rename it back
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Test');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
      expect(find.text(address), findsOneWidget);
    });
  });
}
