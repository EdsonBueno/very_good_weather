import 'dart:async';
import 'dart:math';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:very_good_weather/location_search/bloc/location_search_bloc.dart';
import 'package:very_good_weather/models/temperature_unit.dart';
import 'package:very_good_weather/temperature_unit/cubit/temperature_unit_cubit.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_bloc.g.dart';
part 'weather_event.dart';
part 'weather_helpers.dart';
part 'weather_state.dart';

class WeatherBloc extends HydratedBloc<WeatherEvent, WeatherState> {
  WeatherBloc({
    required WeatherRepository weatherRepository,
    required TemperatureUnitCubit temperatureUnitCubit,
    required LocationSearchBloc locationSearchBloc,
  })   : _temperatureUnitCubit = temperatureUnitCubit,
        _locationSearchBloc = locationSearchBloc,
        _repository = weatherRepository,
        super(const WeatherInitial()) {
    temperatureUnitCubit.stream.listen((newTemperatureUnit) {
      add(WeatherTemperatureUnitChanged(newTemperatureUnit));
    }).addTo(_subscriptionContainer);

    locationSearchBloc.stream.listen((newQuery) {
      add(WeatherNewLocationQueryEntered(newQuery));
    }).addTo(_subscriptionContainer);
  }

  final TemperatureUnitCubit _temperatureUnitCubit;
  final LocationSearchBloc _locationSearchBloc;
  final WeatherRepository _repository;
  final CompositeSubscription _subscriptionContainer = CompositeSubscription();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is WeatherNewLocationQueryEntered) {
      yield* _mapWeatherNewLocationQueryEnteredToState(event.newText);
    } else if (event is WeatherRefreshed) {
      yield* _mapWeatherRefreshedToState();
    } else if (event is WeatherLoadRetried) {
      yield* _mapWeatherLoadRetriedToState();
    } else if (event is WeatherTemperatureUnitChanged) {
      yield* _mapWeatherTemperatureUnitChangedToState(event.newTemperatureUnit);
    }
  }

  Stream<WeatherState> _mapWeatherNewLocationQueryEnteredToState(
    String newQuery,
  ) async* {
    yield* _resetWeatherObservation(newQuery);
  }

  Stream<WeatherState> _mapWeatherRefreshedToState() async* {
    final previousSuccessState = state as WeatherLoadSuccess;
    try {
      final weatherObservation = await _repository.getWeatherObservation(
        previousSuccessState.locationName,
      );

      yield weatherObservation.toWeatherLoadSuccess(
        _temperatureUnitCubit.state,
      );
    } catch (error) {
      yield previousSuccessState.copyWith(
        failedRefreshDate: DateTime.now(),
      );
    }
  }

  Stream<WeatherState> _mapWeatherTemperatureUnitChangedToState(
    TemperatureUnit newTemperatureUnit,
  ) async* {
    final currentState = state;
    if (currentState is WeatherLoadSuccess) {
      yield currentState.copyWithToggledTemperatureUnit(newTemperatureUnit);
    }
  }

  Stream<WeatherState> _mapWeatherLoadRetriedToState() async* {
    yield* _resetWeatherObservation(_locationSearchBloc.state);
  }

  Stream<WeatherState> _resetWeatherObservation(
    String locationQuery,
  ) async* {
    yield const WeatherLoadInProgress();

    try {
      final weatherObservation = await _repository.getWeatherObservation(
        locationQuery,
      );

      yield weatherObservation.toWeatherLoadSuccess(
        _temperatureUnitCubit.state,
      );
    } catch (error) {
      yield WeatherLoadFailure(
        error.toFailureReason(),
      );
    }
  }

  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    return WeatherLoadSuccess.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(WeatherState state) {
    return state is WeatherLoadSuccess ? state.toJson() : null;
  }

  @override
  Future<void> close() {
    _subscriptionContainer.dispose();
    return super.close();
  }
}
