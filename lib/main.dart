import 'package:btc_demo/service_locator.dart';
import 'package:btc_demo/ui/app_widget.dart';
import 'package:flutter/material.dart';

void main() async {
  await setUpInversionOfControl();

  runApp(const AppWidget());
}