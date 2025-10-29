import 'package:btc_demo/service_locator.dart';
import 'package:btc_demo/ui/app_widget.dart';
import 'package:btc_demo/ui/widgets/coin_price_chart_widget/coin_price_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    //Ensure services are initialized before the test runs.
    await setUpInversionOfControl();
  });

  group('Navigation smoke test', () {
    //Loop approach
    testWidgets('should navigate using swipe gestures', (tester) async {

      await tester.pumpWidget(const AppWidget());
      await tester.pumpAndSettle();

      final pageView = find.byType(PageView);
      expect(find.byType(CoinPriceChartWidget), findsOneWidget);

      //Define the sequence of swipes and the expected in-app text for each
      final swipeSteps = [
        (const Offset(-400, 0), find.text('Address:')),
        (const Offset(-400, 0), find.text('Bitcoin')),
        (const Offset(400, 0), find.text('Address:')),
        (const Offset(400, 0), find.byType(CoinPriceChartWidget)),
      ];

      //Navigate the pages using swipe gestures, validate correct page is loaded by finding a fitting element
      for (final step in swipeSteps) {
        await tester.drag(pageView, step.$1);
        await tester.pumpAndSettle();
        expect(step.$2, findsOneWidget);
      }
    });

    //Classic approach
    testWidgets('should navigate through all bottom navigation tabs using taps', (tester) async {

      await tester.pumpWidget(const AppWidget());
      await tester.pumpAndSettle();
      
      //Navigate to Wallet page
      await tester.tap(find.byKey(const ValueKey('nav_wallet_icon')));
      await tester.pumpAndSettle();
      expect(find.text('Address:'), findsOneWidget);

      //Navigate to Market page
      await tester.tap(find.byKey(const ValueKey('nav_market_icon')));
      await tester.pumpAndSettle();
      expect(find.text('Bitcoin'), findsOneWidget);

      //Navigate back to Home page
      await tester.tap(find.byKey(const ValueKey('nav_home_icon')));
      await tester.pumpAndSettle();
    });
  });
}
