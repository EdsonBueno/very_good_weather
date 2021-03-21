// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/weather/bloc/weather_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  group('WeatherState', () {
    group('WeatherInitial', () {
      test('supports equality comparison', () {
        expect(
          WeatherInitial(),
          WeatherInitial(),
        );
      });
    });

    group('WeatherLoadInProgress', () {
      test('supports equality comparison', () {
        expect(
          WeatherLoadInProgress(),
          WeatherLoadInProgress(),
        );
      });
    });

    group('WeatherLoadFailure', () {
      test('supports equality comparison', () {
        expect(
          WeatherLoadFailure(FailureReason.noInternet),
          WeatherLoadFailure(FailureReason.noInternet),
        );
      });
    });

    group('WeatherLoadSuccess', () {
      const locationName = 'San';
      const minimumTemperature = 8.0;
      const maximumTemperature = 16.0;
      const currentTemperature = 15.0;
      const status = WeatherStatus.thunderstorm;
      final updateDate = DateTime.now();
      final weatherLoadSuccess = WeatherLoadSuccess(
        locationName: locationName,
        minimumTemperature: minimumTemperature,
        maximumTemperature: maximumTemperature,
        currentTemperature: currentTemperature,
        status: status,
        updateDate: updateDate,
      );

      test('supports equality comparison', () {
        expect(
          weatherLoadSuccess,
          WeatherLoadSuccess(
            locationName: locationName,
            minimumTemperature: minimumTemperature,
            maximumTemperature: maximumTemperature,
            currentTemperature: currentTemperature,
            status: status,
            updateDate: updateDate,
          ),
        );
      });

      group('serializes status correctly', () {
        test('throws ArgumentError for an unknown status', () {
          final json = {
            'locationName': 'San Francisco',
            'minimumTemperature': 8.0,
            'maximumTemperature': 16.0,
            'currentTemperature': 15.0,
            'status': 'random',
            'updateDate': '2021-03-20T16:11:47.812',
          };
          expect(() => WeatherLoadSuccess.fromJson(json), throwsArgumentError);
        });

        test('parses valid WeatherStatus correctly', () {
          final json = {
            'locationName': 'San Francisco',
            'minimumTemperature': 8.0,
            'maximumTemperature': 16.0,
            'currentTemperature': 15.0,
            'status': 'snow',
            'updateDate': '2021-03-20T16:11:47.812',
          };

          final weatherLoadSuccess = WeatherLoadSuccess.fromJson(json);

          expect(weatherLoadSuccess.status, WeatherStatus.snow);
        });
      });
    });
  });
}
