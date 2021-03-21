part of 'weather_bloc.dart';

extension WeatherStateMappers on WeatherObservation {
  WeatherLoadSuccess toWeatherLoadSuccess(
    TemperatureUnit temperatureUnit,
  ) {
    final shouldConvertTemperaturesToFahrenheit =
        temperatureUnit == TemperatureUnit.fahrenheit;

    final minimumTemperature = shouldConvertTemperaturesToFahrenheit
        ? minimumTemperatureInCelsius.toFahrenheitFromCelsius()
        : minimumTemperatureInCelsius;

    final maximumTemperature = shouldConvertTemperaturesToFahrenheit
        ? maximumTemperatureInCelsius.toFahrenheitFromCelsius()
        : maximumTemperatureInCelsius;

    final currentTemperature = shouldConvertTemperaturesToFahrenheit
        ? currentTemperatureInCelsius.toFahrenheitFromCelsius()
        : currentTemperatureInCelsius;

    return WeatherLoadSuccess(
      locationName: locationName,
      status: status,
      updateDate: DateTime.now(),
      minimumTemperature: minimumTemperature,
      maximumTemperature: maximumTemperature,
      currentTemperature: currentTemperature,
    );
  }
}

extension TemperatureConversionUtils on WeatherLoadSuccess {
  WeatherLoadSuccess copyWithToggledTemperatureUnit(
    TemperatureUnit newTemperatureUnit,
  ) {
    final oldMinimumTemperature = minimumTemperature;
    final oldMaximumTemperature = maximumTemperature;
    final oldCurrentTemperature = currentTemperature;

    final isNewTemperatureUnitFahrenheit =
        newTemperatureUnit == TemperatureUnit.fahrenheit;

    final newMinimumTemperature = isNewTemperatureUnitFahrenheit
        ? oldMinimumTemperature.toFahrenheitFromCelsius()
        : oldMinimumTemperature.toCelsiusFromFahrenheit();

    final newMaximumTemperature = isNewTemperatureUnitFahrenheit
        ? oldMaximumTemperature.toFahrenheitFromCelsius()
        : oldMaximumTemperature.toCelsiusFromFahrenheit();

    final newCurrentTemperature = isNewTemperatureUnitFahrenheit
        ? oldCurrentTemperature.toFahrenheitFromCelsius()
        : oldCurrentTemperature.toCelsiusFromFahrenheit();

    return copyWith(
      minimumTemperature: newMinimumTemperature,
      maximumTemperature: newMaximumTemperature,
      currentTemperature: newCurrentTemperature,
    );
  }
}

extension FailureReasonMappers on Object {
  FailureReason toFailureReason() {
    if (this is NoInternetException) {
      return FailureReason.noInternet;
    } else if (this is LocationNotFoundException) {
      return FailureReason.locationNotFound;
    }

    return FailureReason.unknown;
  }
}

extension on double {
  double toFahrenheitFromCelsius() => ((this * 9 / 5) + 32);

  double toCelsiusFromFahrenheit() => ((this - 32) * 5 / 9);

  double toPrecision(int fractionDigitCount) {
    final mod = pow(10, fractionDigitCount).toDouble();
    return ((this * mod).round().toDouble() / mod);
  }
}
