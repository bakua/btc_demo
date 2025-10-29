import 'package:btc_demo/ui/home/home_page.dart';
import 'package:btc_demo/ui/profile/profile_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BTC Wallet',
      theme: ThemeData(
        useMaterial3: true,
        // Normally I would recommend to use a custom text theme,
        // respecting the company design language and then using theme.textTheme.title/body/headline1/etc.
        textTheme: Typography.whiteHelsinki,
        colorScheme: const ColorScheme.light(
          primary: Colors.deepOrange,
        ),
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ProfilePage.routeName: (context) => const ProfilePage(),
      },
    );
  }
}
