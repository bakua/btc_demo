import 'package:btc_demo/service_locator.dart';
import 'package:btc_demo/ui/home/bloc/home_bloc.dart';
import 'package:btc_demo/ui/widgets/background_widget/background_widget.dart';
import 'package:btc_demo/ui/widgets/bitcoin_balance_widget.dart';
import 'package:btc_demo/ui/widgets/coin_price_chart_widget/coin_price_chart_widget.dart';
import 'package:btc_demo/ui/widgets/fiat_balance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: BackgroundWidget()),
        BlocProvider(
          create: (context) => HomeBloc(inject(), inject())..add(LoadHomeEvent()),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              switch (state) {
                case HomeInitialState():
                  return const Center(child: CircularProgressIndicator());
                case HomeFailedState():
                  return Center(child: Text('Failed to load data\nPlease try again later\n${state.error}'));
                case HomeSuccessState():
                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: BitcoinBalanceWidget(wallet: state.wallet, btcToUsdPrice: state.btcToUsdPrice),
                        ),
                        const SizedBox(height: 42),
                        const CoinPriceChartWidget(coinId: 'bitcoin'),
                        const Spacer(),
                        FiatBalanceCardWidget(wallet: state.wallet),
                        const SizedBox(height: 4),
                      ],
                    ),
                  );
              }
            },
          ),
        ),
      ],
    );
  }
}
