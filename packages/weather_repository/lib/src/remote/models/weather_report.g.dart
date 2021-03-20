// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherReport _$WeatherReportFromJson(Map<String, dynamic> json) {
  return $checkedNew('WeatherReport', json, () {
    final val = WeatherReport(
      dailyWeatherList: $checkedConvert(
          json,
          'consolidated_weather',
          (v) => (v as List<dynamic>)
              .map((e) => DailyWeather.fromJson(e as Map<String, dynamic>))
              .toList()),
    );
    return val;
  }, fieldKeyMap: const {'dailyWeatherList': 'consolidated_weather'});
}
