import 'package:btc_demo/ui/home/home_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  //todo use navigator
  static const String routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //todo either drop this or explan why it exists
    return const HomeWidget();
  }
}
