import 'dart:io';

import 'mappers/remote_to_domain.dart';
import 'models/models.dart';
import 'remote/weather_remote_data_provider.dart';

class WeatherRepository {
  WeatherRepository({
    WeatherRemoteDataProvider? remoteDataProvider,
  }) : _remoteDataProvider = remoteDataProvider ?? WeatherRemoteDataProvider();

  final WeatherRemoteDataProvider _remoteDataProvider;

  Future<WeatherObservation> getWeatherObservation(String locationQuery) async {
    try {
      final location = await _remoteDataProvider.searchLocation(locationQuery);
      final currentWeather =
          await _remoteDataProvider.getCurrentWeather(location.id);

      return currentWeather.toWeatherObservation(location.name);
    } catch (error) {
      if (error is EmptySearchResultException) {
        throw LocationNotFoundException();
      } else if (error is SocketException) {
        throw NoInternetException();
      } else {
        rethrow;
      }
    }
  }
}
