import 'package:equatable/equatable.dart';

import 'weather_status.dart';

class WeatherObservation extends Equatable {
  const WeatherObservation({
    required this.locationName,
    required this.minimumTemperatureInCelsius,
    required this.maximumTemperatureInCelsius,
    required this.currentTemperatureInCelsius,
    required this.status,
  });

  final String locationName;

  final double minimumTemperatureInCelsius;

  final double maximumTemperatureInCelsius;

  final double currentTemperatureInCelsius;

  final WeatherStatus status;

  @override
  List<Object?> get props => [
        locationName,
        minimumTemperatureInCelsius,
        maximumTemperatureInCelsius,
        currentTemperatureInCelsius,
        status,
      ];
}
