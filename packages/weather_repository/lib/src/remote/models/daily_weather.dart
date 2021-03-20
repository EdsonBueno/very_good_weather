import 'package:json_annotation/json_annotation.dart';

part 'daily_weather.g.dart';

@JsonSerializable()
class DailyWeather {
  DailyWeather({
    required this.minimumTemperatureInCelsius,
    required this.maximumTemperatureInCelsius,
    required this.currentTemperatureInCelsius,
    required this.statusAbbreviation,
  });

  @JsonKey(name: 'min_temp')
  final double minimumTemperatureInCelsius;

  @JsonKey(name: 'max_temp')
  final double maximumTemperatureInCelsius;

  @JsonKey(name: 'the_temp')
  final double currentTemperatureInCelsius;

  /// One or two letter abbreviation of the weather status.
  @JsonKey(name: 'weather_state_abbr')
  final String statusAbbreviation;

  static const fromJson = _$DailyWeatherFromJson;
}
