import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:weather_repository/src/models/exceptions.dart';
import 'package:weather_repository/src/remote/models/daily_weather.dart';
import 'package:weather_repository/src/remote/models/location.dart';
import 'package:weather_repository/src/remote/weather_remote_data_provider.dart';
import 'package:weather_repository/src/weather_repository.dart';

class MockWeatherRemoteDataProvider extends Mock
    implements WeatherRemoteDataProvider {}

void main() {
  group('WeatherRepository', () {
    late WeatherRepository weatherRepository;
    late MockWeatherRemoteDataProvider remoteDataProvider;

    setUp(() {
      remoteDataProvider = MockWeatherRemoteDataProvider();
      weatherRepository = WeatherRepository(
        remoteDataProvider: remoteDataProvider,
      );
    });

    test('instantiates without needing a WeatherRemoteDataProvider instance',
        () {
      expect(WeatherRepository(), isNotNull);
    });

    group('getWeatherObservation', () {
      test('uses the obtained location id to get the current weather',
          () async {
        const locationId = 3839;
        const locationQuery = 'san';
        when(
          () => remoteDataProvider.searchLocation(locationQuery),
        ).thenAnswer(
          (_) async => Location(id: locationId, name: 'San Francisco'),
        );

        when(
          () => remoteDataProvider.getCurrentWeather(locationId),
        ).thenAnswer(
          (_) async => DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 'lr',
          ),
        );

        await weatherRepository.getWeatherObservation(
          locationQuery,
        );

        verify(
          () => remoteDataProvider.getCurrentWeather(locationId),
        ).called(1);
      });

      test('uses obtained location name to create the [WeatherObservation]',
          () async {
        const locationName = 'San Francisco';
        const locationId = 3839;
        const locationQuery = 'san';

        when(
          () => remoteDataProvider.searchLocation(locationQuery),
        ).thenAnswer(
          (_) async => Location(id: locationId, name: 'San Francisco'),
        );

        when(
          () => remoteDataProvider.getCurrentWeather(locationId),
        ).thenAnswer(
          (_) async => DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 'lr',
          ),
        );

        final weatherObservation =
            await weatherRepository.getWeatherObservation(locationQuery);

        expect(weatherObservation.locationName, locationName);
      });

      group('error handling', () {
        test('throws LocationNotFoundException on EmptySearchResultException',
            () {
          when(
            () => remoteDataProvider.searchLocation(any()),
          ).thenAnswer(
            (_) => throw EmptySearchResultException(),
          );

          expect(
            () async => await weatherRepository.getWeatherObservation('san'),
            throwsA(
              isA<LocationNotFoundException>(),
            ),
          );
        });

        test('throws NoInternetException on SocketException', () {
          when(
            () => remoteDataProvider.searchLocation(any()),
          ).thenAnswer(
            (_) => throw const SocketException(''),
          );

          expect(
            () async => await weatherRepository.getWeatherObservation('san'),
            throwsA(
              isA<NoInternetException>(),
            ),
          );
        });

        test('rethrows unexpected exceptions', () {
          when(
            () => remoteDataProvider.searchLocation(any()),
          ).thenAnswer(
            (_) => throw const SignalException(''),
          );

          expect(
            () async => await weatherRepository.getWeatherObservation('san'),
            throwsA(
              isA<SignalException>(),
            ),
          );
        });
      });
    });
  });
}
