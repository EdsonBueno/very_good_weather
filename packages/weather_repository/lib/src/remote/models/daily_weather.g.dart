// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyWeather _$DailyWeatherFromJson(Map<String, dynamic> json) {
  return $checkedNew('DailyWeather', json, () {
    final val = DailyWeather(
      minimumTemperatureInCelsius:
          $checkedConvert(json, 'min_temp', (v) => (v as num).toDouble()),
      maximumTemperatureInCelsius:
          $checkedConvert(json, 'max_temp', (v) => (v as num).toDouble()),
      currentTemperatureInCelsius:
          $checkedConvert(json, 'the_temp', (v) => (v as num).toDouble()),
      statusAbbreviation:
          $checkedConvert(json, 'weather_state_abbr', (v) => v as String),
    );
    return val;
  }, fieldKeyMap: const {
    'minimumTemperatureInCelsius': 'min_temp',
    'maximumTemperatureInCelsius': 'max_temp',
    'currentTemperatureInCelsius': 'the_temp',
    'statusAbbreviation': 'weather_state_abbr'
  });
}
