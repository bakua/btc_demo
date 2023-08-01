class BackendApi {
  Future<double> getBtcBalance() async {
    await Future.delayed(const Duration(seconds: 1));
    return 2.1524350815097164;
  }
}
