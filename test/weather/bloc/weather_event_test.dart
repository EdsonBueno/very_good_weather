// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/models/temperature_unit.dart';
import 'package:very_good_weather/weather/bloc/weather_bloc.dart';

void main() {
  group('WeatherEvent', () {
    group('WeatherNewLocationQueryEntered', () {
      test('supports equality comparison', () {
        const locationQuery = 'San';
        expect(
          WeatherNewLocationQueryEntered(locationQuery),
          WeatherNewLocationQueryEntered(locationQuery),
        );
      });
    });

    group('WeatherRefreshed', () {
      test('supports equality comparison', () {
        expect(
          WeatherRefreshed(),
          WeatherRefreshed(),
        );
      });
    });

    group('WeatherLoadRetried', () {
      test('supports equality comparison', () {
        expect(
          WeatherLoadRetried(),
          WeatherLoadRetried(),
        );
      });
    });

    group('WeatherTemperatureUnitChanged', () {
      test('supports equality comparison', () {
        expect(
          WeatherTemperatureUnitChanged(TemperatureUnit.fahrenheit),
          WeatherTemperatureUnitChanged(TemperatureUnit.fahrenheit),
        );
      });
    });
  });
}
