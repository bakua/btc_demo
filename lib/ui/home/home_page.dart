import 'package:btc_demo/ui/home/home_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.support_agent_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
            ],
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: const HomeWidget(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
            BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Market'),
          ],
        ));

  }
}
