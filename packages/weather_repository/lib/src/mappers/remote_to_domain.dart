import '../models/models.dart';
import '../remote/models/models.dart';

extension DailyWeatherToCurrentWeather on DailyWeather {
  WeatherObservation toWeatherObservation(String locationName) =>
      WeatherObservation(
        locationName: locationName,
        minimumTemperatureInCelsius: minimumTemperatureInCelsius,
        maximumTemperatureInCelsius: maximumTemperatureInCelsius,
        currentTemperatureInCelsius: currentTemperatureInCelsius,
        status: statusAbbreviation.toWeatherStatus(),
      );
}

extension on String {
  WeatherStatus toWeatherStatus() {
    switch (this) {
      case 'sn':
        return WeatherStatus.snow;
      case 'sl':
        return WeatherStatus.sleet;
      case 'h':
        return WeatherStatus.hail;
      case 't':
        return WeatherStatus.thunderstorm;
      case 'hr':
        return WeatherStatus.heavyRain;
      case 'lr':
        return WeatherStatus.lightRain;
      case 's':
        return WeatherStatus.showers;
      case 'hc':
        return WeatherStatus.heavyCloud;
      case 'lc':
        return WeatherStatus.lightCloud;
      case 'c':
        return WeatherStatus.clear;
      default:
        throw UnknownWeatherStateException();
    }
  }
}

class UnknownWeatherStateException implements Exception {}
