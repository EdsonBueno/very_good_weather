import 'package:dio/dio.dart';
import 'package:weather_repository/src/remote/meta_weather_api_url_builder.dart';

import 'models/models.dart';

class EmptySearchResultException implements Exception {}

class WeatherRemoteDataProvider {
  WeatherRemoteDataProvider({
    Dio? dio,
    MetaWeatherApiUrlBuilder? urlBuilder,
  })  : _dio = dio ?? Dio(),
        _urlBuilder = urlBuilder ?? MetaWeatherApiUrlBuilder();

  final Dio _dio;
  final MetaWeatherApiUrlBuilder _urlBuilder;

  Future<DailyWeather> getCurrentWeather(int locationId) async {
    final weatherReport = await _get5DayWeatherReport(locationId);
    final todayDailyWeather = weatherReport.dailyWeatherList.first;
    return todayDailyWeather;
  }

  Future<Location> searchLocation(String query) async {
    final url = _urlBuilder.buildGetLocationUrl(query);
    final response = await _dio.get(url);

    final List<dynamic> jsonArray = response.data;
    if (jsonArray.isEmpty) {
      throw EmptySearchResultException();
    }

    final locationResultList = jsonArray
        .map(
          (jsonObject) => Location.fromJson(jsonObject),
        )
        .toList();

    final mostLikelyLocation = locationResultList.first;

    return mostLikelyLocation;
  }

  Future<WeatherReport> _get5DayWeatherReport(int locationId) async {
    final url = _urlBuilder.buildGet5DayWeatherReportUrl(locationId);
    final response = await _dio.get(url);
    final jsonObject = response.data;
    final weatherReport = WeatherReport.fromJson(jsonObject);
    return weatherReport;
  }
}
