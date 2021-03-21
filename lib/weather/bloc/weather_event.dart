part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class WeatherNewLocationQueryEntered extends WeatherEvent {
  const WeatherNewLocationQueryEntered(
    this.newText,
  );

  final String newText;

  @override
  List<Object?> get props => [newText];
}

class WeatherRefreshed extends WeatherEvent {
  const WeatherRefreshed();
}

class WeatherLoadRetried extends WeatherEvent {
  const WeatherLoadRetried();
}

class WeatherTemperatureUnitChanged extends WeatherEvent {
  const WeatherTemperatureUnitChanged(
    this.newTemperatureUnit,
  );

  final TemperatureUnit newTemperatureUnit;

  @override
  List<Object?> get props => [newTemperatureUnit];
}
