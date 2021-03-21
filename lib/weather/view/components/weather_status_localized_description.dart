import 'package:flutter/widgets.dart';
import 'package:very_good_weather/l10n/l10n.dart';
import 'package:weather_repository/weather_repository.dart';

/// Displays a localized description of [status].
class WeatherStatusLocalizedDescription extends StatelessWidget {
  const WeatherStatusLocalizedDescription({
    Key? key,
    required this.status,
  }) : super(key: key);

  final WeatherStatus status;

  @override
  Widget build(BuildContext context) => Text(
        status.toLocalizedDescription(context),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      );
}

extension on WeatherStatus {
  String toLocalizedDescription(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case WeatherStatus.snow:
        return l10n.weatherSnowStatusTitle;
      case WeatherStatus.sleet:
        return l10n.weatherSleetStatusTitle;
      case WeatherStatus.hail:
        return l10n.weatherHailStatusTitle;
      case WeatherStatus.thunderstorm:
        return l10n.weatherThunderstormStatusTitle;
      case WeatherStatus.heavyRain:
        return l10n.weatherHeavyRainStatusTitle;
      case WeatherStatus.lightRain:
        return l10n.weatherLightRainStatusTitle;
      case WeatherStatus.showers:
        return l10n.weatherShowersStatusTitle;
      case WeatherStatus.heavyCloud:
        return l10n.weatherHeavyCloudStatusTitle;
      case WeatherStatus.lightCloud:
        return l10n.weatherLightCloudStatusTitle;
      default:
        return l10n.weatherClearStatusTitle;
    }
  }
}
