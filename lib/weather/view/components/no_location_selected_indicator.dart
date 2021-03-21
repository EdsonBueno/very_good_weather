import 'package:flutter/material.dart';
import 'package:very_good_weather/l10n/l10n.dart';

class NoLocationSelectedIndicator extends StatelessWidget {
  const NoLocationSelectedIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.weatherInitialInstruction,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }
}
