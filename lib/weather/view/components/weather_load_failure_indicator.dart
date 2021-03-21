import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_weather/l10n/l10n.dart';
import 'package:very_good_weather/weather/bloc/weather_bloc.dart';

class WeatherLoadFailureIndicator extends StatelessWidget {
  const WeatherLoadFailureIndicator({
    Key? key,
    required this.failureReason,
  }) : super(key: key);

  final FailureReason failureReason;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 96,
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              failureReason.toLocalizedDescription(context),
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            if (failureReason != FailureReason.locationNotFound)
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: const Key(
                    'weatherLoadFailureIndicator_tryAgain_elevatedButton',
                  ),
                  onPressed: () {
                    context.read<WeatherBloc>().add(
                          const WeatherLoadRetried(),
                        );
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  label: Text(
                    context.l10n.weatherLoadFailureTryAgainAction,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension on FailureReason {
  String toLocalizedDescription(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case FailureReason.locationNotFound:
        return l10n.weatherLoadFailureLocationNotFoundDescription;
      case FailureReason.noInternet:
        return l10n.weatherLoadFailureNoInternetDescription;
      default:
        return l10n.weatherLoadFailureUnknownDescription;
    }
  }
}
