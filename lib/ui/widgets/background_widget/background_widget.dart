import 'package:btc_demo/ui/widgets/background_widget/bitcoin_icon_widget.dart';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const Positioned(top: 60, right: -120, child: BitcoinIconWidget(size: 280)),
      ],
    );
  }
}
