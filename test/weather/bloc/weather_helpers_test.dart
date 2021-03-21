import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/models/temperature_unit.dart';
import 'package:very_good_weather/weather/bloc/weather_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  // Useful declarations.
  const locationName = 'San Francisco';
  const minimumTemperatureInCelsius = 7.0;
  const minimumTemperatureInFahrenheit = 44.6;
  const maximumTemperatureInCelsius = 15.0;
  const maximumTemperatureInFahrenheit = 59.0;
  const currentTemperatureInCelsius = 14.0;
  const currentTemperatureInFahrenheit = 57.2;

  group('WeatherStateMappers', () {
    group('toWeatherLoadSuccess', () {
      final weatherObservationInCelsius = const WeatherObservation(
        locationName: locationName,
        minimumTemperatureInCelsius: minimumTemperatureInCelsius,
        maximumTemperatureInCelsius: maximumTemperatureInCelsius,
        currentTemperatureInCelsius: currentTemperatureInCelsius,
        status: WeatherStatus.lightCloud,
      );

      test('converts minimumTemperature to Fahrenheit if needed', () {
        final successState = weatherObservationInCelsius.toWeatherLoadSuccess(
          TemperatureUnit.fahrenheit,
        );

        expect(
          successState.minimumTemperature,
          moreOrLessEquals(minimumTemperatureInFahrenheit),
        );
      });

      test('converts maximumTemperature to Fahrenheit if needed', () {
        final successState = weatherObservationInCelsius.toWeatherLoadSuccess(
          TemperatureUnit.fahrenheit,
        );

        expect(
          successState.maximumTemperature,
          moreOrLessEquals(maximumTemperatureInFahrenheit),
        );
      });

      test('converts currentTemperature to Fahrenheit if needed', () {
        final successState = weatherObservationInCelsius.toWeatherLoadSuccess(
          TemperatureUnit.fahrenheit,
        );

        expect(
          successState.currentTemperature,
          moreOrLessEquals(currentTemperatureInFahrenheit),
        );
      });
    });
  });

  group('TemperatureConversionUtils', () {
    group('copyWithToggledTemperatureUnit', () {
      group('converts temperatures from Celsius to Fahrenheit', () {
        final weatherLoadSuccessInCelsius = WeatherLoadSuccess(
          locationName: locationName,
          minimumTemperature: minimumTemperatureInCelsius,
          maximumTemperature: maximumTemperatureInCelsius,
          currentTemperature: currentTemperatureInCelsius,
          status: WeatherStatus.lightCloud,
          updateDate: DateTime.now(),
        );

        test('converts minimumTemperature to Fahrenheit', () {
          final weatherLoadSuccessInFahrenheit =
              weatherLoadSuccessInCelsius.copyWithToggledTemperatureUnit(
            TemperatureUnit.fahrenheit,
          );

          expect(
            weatherLoadSuccessInFahrenheit.minimumTemperature,
            moreOrLessEquals(minimumTemperatureInFahrenheit),
          );
        });

        test('converts maximumTemperature to Fahrenheit', () {
          final weatherLoadSuccessInFahrenheit =
              weatherLoadSuccessInCelsius.copyWithToggledTemperatureUnit(
            TemperatureUnit.fahrenheit,
          );

          expect(
            weatherLoadSuccessInFahrenheit.maximumTemperature,
            moreOrLessEquals(maximumTemperatureInFahrenheit),
          );
        });

        test('converts currentTemperature to Fahrenheit', () {
          final weatherLoadSuccessInFahrenheit =
              weatherLoadSuccessInCelsius.copyWithToggledTemperatureUnit(
            TemperatureUnit.fahrenheit,
          );

          expect(
            weatherLoadSuccessInFahrenheit.currentTemperature,
            moreOrLessEquals(currentTemperatureInFahrenheit),
          );
        });
      });

      group('converts temperatures from Fahrenheit to Celsius', () {
        final weatherLoadSuccessInFahrenheit = WeatherLoadSuccess(
          locationName: locationName,
          minimumTemperature: minimumTemperatureInFahrenheit,
          maximumTemperature: maximumTemperatureInFahrenheit,
          currentTemperature: currentTemperatureInFahrenheit,
          status: WeatherStatus.lightCloud,
          updateDate: DateTime.now(),
        );

        test('converts minimumTemperature to Celsius', () {
          final weatherLoadSuccessInCelsius =
              weatherLoadSuccessInFahrenheit.copyWithToggledTemperatureUnit(
            TemperatureUnit.celsius,
          );

          expect(
            weatherLoadSuccessInCelsius.minimumTemperature,
            moreOrLessEquals(minimumTemperatureInCelsius),
          );
        });

        test('converts maximumTemperature to Celsius', () {
          final weatherLoadSuccessInCelsius =
              weatherLoadSuccessInFahrenheit.copyWithToggledTemperatureUnit(
            TemperatureUnit.celsius,
          );

          expect(
            weatherLoadSuccessInCelsius.maximumTemperature,
            moreOrLessEquals(maximumTemperatureInCelsius),
          );
        });

        test('converts currentTemperature to Celsius', () {
          final weatherLoadSuccessInCelsius =
              weatherLoadSuccessInFahrenheit.copyWithToggledTemperatureUnit(
            TemperatureUnit.celsius,
          );

          expect(
            weatherLoadSuccessInCelsius.currentTemperature.roundToDouble(),
            moreOrLessEquals(currentTemperatureInCelsius),
          );
        });
      });

      test('sets isFromFailedRefresh back to false', () {
        final failedRefreshSuccessState = WeatherLoadSuccess(
          locationName: locationName,
          minimumTemperature: minimumTemperatureInCelsius,
          maximumTemperature: maximumTemperatureInCelsius,
          currentTemperature: currentTemperatureInCelsius,
          status: WeatherStatus.lightCloud,
          updateDate: DateTime.now(),
          failedRefreshDate: DateTime.now(),
        );

        final convertedState =
            failedRefreshSuccessState.copyWithToggledTemperatureUnit(
          TemperatureUnit.fahrenheit,
        );

        expect(convertedState.isFromFailedRefresh, false);
      });
    });
  });

  group('FailureReasonMappers', () {
    group('toFailureReason', () {
      test('maps NoInternetException to FailureReason.noInternet', () {
        final noInternetException = NoInternetException();
        final failureReason = noInternetException.toFailureReason();
        expect(failureReason, FailureReason.noInternet);
      });

      test('maps LocationNotFoundException to FailureReason.locationNotFound',
          () {
        final locationNotFoundException = LocationNotFoundException();
        final failureReason = locationNotFoundException.toFailureReason();
        expect(failureReason, FailureReason.locationNotFound);
      });

      test('maps any other object to FailureReason.unknown', () {
        final randomException = const FormatException();
        final failureReason = randomException.toFailureReason();
        expect(failureReason, FailureReason.unknown);
      });
    });
  });
}
