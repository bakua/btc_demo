import 'package:btc_demo/lib/coins_price_repository.dart';
import 'package:btc_demo/lib/text.dart';
import 'package:btc_demo/service_locator.dart';
import 'package:btc_demo/ui/app_widget.dart';
import 'package:btc_demo/ui/widgets/coin_price_chart_widget/coin_price_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:number_to_text_converter/number_to_text_converter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    //Ensure services are initialized before the test runs.
    await setUpInversionOfControl();
  });

  group('Home page tests', () {
    //Attempt to solve the occassional test hangs at startup. Honestly, this is mostly LLM. But it helps.
    Future<void> waitForDataToLoad(WidgetTester tester) async {
      await Future.delayed(const Duration(seconds: 3));
      const timeout = Duration(seconds: 10);
      final end = tester.binding.clock.now().add(timeout);
      do {
        if (tester.binding.clock.now().isAfter(end)) {
          final errorFinder = find.textContaining('Failed to load data');
          if (errorFinder.evaluate().isNotEmpty) {
            fail('Test failed because the app could not load its initial data.');
          } else {
            fail('Timed out waiting for CoinPriceChartWidget to appear.');
          }
        }
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(milliseconds: 100));
      } while (find.byType(CoinPriceChartWidget).evaluate().isEmpty);
    }

    testWidgets('should check all the listed values and BTC price are correct', (tester) async {
      //Fetch the BTC price
      final coinsPriceRepository = inject<CoinsPriceRepository>();
      final btcPrice = await coinsPriceRepository.getBtcToUsdPrice();
      print('Fetched BTC price from API: \$$btcPrice');

      await tester.pumpWidget(const AppWidget());
      await waitForDataToLoad(tester);

      //Get the displayed price
      final priceTagFinder = find.byKey(const ValueKey('btc_price_tag'));
      expect(priceTagFinder, findsOneWidget);

      final Text priceTagWidget = tester.widget(priceTagFinder);
      final displayText = priceTagWidget.data;
      print('Displayed text on screen: $displayText');

      //Format the API price to match the UI format and compare
      final expectedText = '(1 BTC = ${formatUSD(btcPrice)})';
      expect(displayText, expectedText);

      final fiatBalanceFinder = find.byKey(const ValueKey('fiat_balance'));
      expect(fiatBalanceFinder, findsOneWidget);
      final Text fiatBalanceWidget = tester.widget(fiatBalanceFinder);
      final fiatDisplayText = fiatBalanceWidget.data;

      //Calculate and format the expected fiat balance and compare
      const btcBalance = 2.1524350815097164; // The hardcoded balance from the mock backend.
      final expectedFiatBalance = btcPrice * btcBalance;
      final expectedFiatText = formatUSD(expectedFiatBalance);
      expect(fiatDisplayText, expectedFiatText);
      print('The math checks out');

      final numberToWordsFinder = find.byKey(const ValueKey('number_to_words'));
      expect(numberToWordsFinder, findsOneWidget);
      final RichText numberToWordsWidget = tester.widget(numberToWordsFinder);
      final displayedWordsText = (numberToWordsWidget.text as TextSpan).toPlainText();

      //Convert the calculated balance to words using the same logic as the UI
      final converter = NumberToTextConverter.forInternationalNumberingSystem();
      final expectedWordsText = converter.convert(expectedFiatBalance.toInt());

      //Compare the displayed words with the expected words.
      expect(displayedWordsText, expectedWordsText);
      print('The number to words conversion checks out');
      print('All displayed values are correct');
    });

    //I would also check the presence of tooltip, and if the values in it are changing/correct
    //But I cannot seem to get that working, the tooltips keeps disappearing. Abandoning
    testWidgets('should allow horizontal swiping on the price chart', (tester) async {
      await tester.pumpWidget(const AppWidget());
      await tester.pumpAndSettle();

      //Find chart widget, set coordinates
      final chartFinder = find.byType(CoinPriceChartWidget);
      expect(chartFinder, findsOneWidget);

      final chartRect = tester.getRect(chartFinder);
      final startPoint = chartRect.bottomLeft + Offset(chartRect.width * 0.25, -chartRect.height * 0.30);
      final endPoint = chartRect.bottomRight + Offset(-chartRect.width * 0.25, -chartRect.height * 0.30);

      //Slow drag gesture over 5 seconds.
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));
      final gesture = await tester.startGesture(startPoint);
      await tester.pump(const Duration(milliseconds: 200));

      const steps = 50;
      final stepOffset = (endPoint - startPoint) / steps.toDouble();
      for (var i = 0; i < steps; i++) {
        await gesture.moveBy(stepOffset);
        await tester.pump(const Duration(milliseconds: 100));
      }

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
