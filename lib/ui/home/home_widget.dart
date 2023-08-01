import 'package:btc_demo/lib/text.dart';
import 'package:btc_demo/ui/home/background_widget.dart';
import 'package:btc_demo/ui/home/bitcoin_icon_widget.dart';
import 'package:btc_demo/ui/widgets/coin_price_chart_widget/coin_price_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:number_to_text_converter/number_to_text_converter.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

//todo text style white
class _HomeWidgetState extends State<HomeWidget> {
  final converter = NumberToTextConverter.forInternationalNumberingSystem();

  @override
  Widget build(BuildContext context) {
    final usdAmount = 63245.23;
    final btcAmount = 2.1524350815097164;

    final wholeBtcAmount = btcAmount.floor();
    final fractionalBtcAmount = btcAmount - wholeBtcAmount;

    final textNumber = converter.convert(usdAmount.toInt());
    final lines = textNumber.split(' ');

    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.support_agent_outlined)),
              IconButton(onPressed: () {}, icon: Icon(Icons.person_outline)),
            ],
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned.fill(child: BackgroundWidget()),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32),
                        Text('Bitcoin', style: TextStyle(fontSize: 18, color: Colors.white)),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: wholeBtcAmount.toString()),
                              TextSpan(text: fractionalBtcAmount.toStringAsFixed(2).substring(1), style: TextStyle(color: Colors.white70)),
                              WidgetSpan(child: SizedBox(width: 8)),
                              TextSpan(text: 'BTC', style: TextStyle(fontSize: 32, fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Text('(1 BTC = \$26 915)', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  SizedBox(height: 42),
                  CoinPriceChartWidget(coinId: 'bitcoin'),
                  Spacer(),
                  Card(
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
                              children: [
                                Text('Fiat balance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryColor)),
                                SizedBox(height: 8),
                                Text(formatCurrency(usdAmount, 'USD', symbol: '\$'),
                                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87)),
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
                                SizedBox(height: 32),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Withdraw', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
            BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Market'),
          ],
        ));
  }
}
