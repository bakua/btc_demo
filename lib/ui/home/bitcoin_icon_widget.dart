import 'package:btc_demo/ui/home/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:number_to_text_converter/number_to_text_converter.dart';

class BitcoinIconWidget extends StatelessWidget {
  final double size;

  const BitcoinIconWidget({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Transform.rotate(
      angle: .3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.circle, size: size * 1.5, color: Colors.white10),
          Icon(Icons.currency_bitcoin, size: size, color: theme.primaryColor.withOpacity(.7)),
        ],
      ),
    );
  }
}
