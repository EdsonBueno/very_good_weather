import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_weather/l10n/l10n.dart';
import 'package:very_good_weather/weather/bloc/weather_bloc.dart';
import 'package:very_good_weather/weather/view/components/components.dart';

class WeatherObservationView extends StatelessWidget {
  const WeatherObservationView({
    required this.weatherObservation,
    this.shouldAnimateIllustration = true,
    Key? key,
  }) : super(key: key);

  final WeatherLoadSuccess weatherObservation;
  final bool shouldAnimateIllustration;

  @override
  Widget build(BuildContext context) {
    final locationName = weatherObservation.locationName;
    final lastUpdateDate = weatherObservation.updateDate;
    final weatherStatus = weatherObservation.status;

    return RefreshIndicator(
      onRefresh: () {
        final bloc = context.read<WeatherBloc>()
          ..add(
            const WeatherRefreshed(),
          );
        final stateChangeFuture = bloc.stream.first;
        return stateChangeFuture;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        child: Column(
          children: [
            WeatherStatusIllustration(
              status: weatherStatus,
              shouldAnimate: shouldAnimateIllustration,
            ),
            const SizedBox(
              height: 16,
            ),
            LocationText(
              text: locationName,
            ),
            const SizedBox(
              height: 22,
            ),
            _WeatherObservationDetails(
              weatherObservation: weatherObservation,
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              context.l10n.weatherObservationLastUpdateDate(
                lastUpdateDate,
                lastUpdateDate,
              ),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherObservationDetails extends StatelessWidget {
  const _WeatherObservationDetails({
    Key? key,
    required this.weatherObservation,
  }) : super(key: key);

  final WeatherLoadSuccess weatherObservation;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.weatherObservationCurrentTemperature(
            weatherObservation.currentTemperature.round(),
          ),
          style: const TextStyle(
            fontSize: 68,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          width: 22,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeatherStatusLocalizedDescription(
              status: weatherObservation.status,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              l10n.weatherObservationMinimumAndMaximumTemperature(
                weatherObservation.minimumTemperature.round(),
                weatherObservation.maximumTemperature.round(),
              ),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
