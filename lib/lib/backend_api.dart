import 'package:btc_demo/lib/model/wallet.dart';

class BackendApi {
  Future<double> getBtcBalance() async {
    await Future.delayed(Duration(seconds: 1));
    return 2.1524350815097164;
  }
}