import 'package:json_annotation/json_annotation.dart';

import 'daily_weather.dart';

part 'weather_report.g.dart';

@JsonSerializable()
class WeatherReport {
  WeatherReport({
    required this.dailyWeatherList,
  });

  /// 5-day weather forecast list.
  @JsonKey(name: 'consolidated_weather')
  final List<DailyWeather> dailyWeatherList;

  static const fromJson = _$WeatherReportFromJson;
}
