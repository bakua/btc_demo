import 'package:btc_demo/service_locator.dart';
import 'package:btc_demo/ui/home/bloc/home_bloc.dart';
import 'package:btc_demo/ui/home/home_widget.dart';
import 'package:btc_demo/ui/market/market_page.dart';
import 'package:btc_demo/ui/profile/profile_page.dart';
import 'package:btc_demo/ui/wallet/wallet_page.dart';
import 'package:btc_demo/ui/widgets/background_widget/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final HomeBloc _homeBloc;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(inject(), inject())..add(LoadHomeEvent());
    _pageController = PageController();
  }

  @override
  void dispose() {
    _homeBloc.close();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      const HomeWidget(),
      WalletPage(),
      const MarketPage(),
    ];

    return BlocProvider.value(
      value: _homeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(key: const ValueKey('support_button'), onPressed: () {}, icon: const Icon(Icons.support_agent_outlined)),
              IconButton(
                  key: const ValueKey('profile_button'),
                  onPressed: () => Navigator.of(context).pushNamed(ProfilePage.routeName),
                  icon: const Icon(Icons.person_outline)),
            ],
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            const Positioned.fill(child: BackgroundWidget()),
            SafeArea(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: widgetOptions,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1F222A),
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), key: ValueKey('nav_home_icon'), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined), key: ValueKey('nav_wallet_icon'), label: 'Wallet'),
            BottomNavigationBarItem(
                icon: Icon(Icons.storefront_outlined), key: ValueKey('nav_market_icon'), label: 'Market'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
