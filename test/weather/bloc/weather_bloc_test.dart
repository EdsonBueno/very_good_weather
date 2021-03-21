import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/location_search/bloc/location_search_bloc.dart';
import 'package:very_good_weather/models/temperature_unit.dart';
import 'package:very_good_weather/temperature_unit/cubit/temperature_unit_cubit.dart';
import 'package:very_good_weather/weather/bloc/weather_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/helpers.dart';

const sanFranciscoWeatherObservation = WeatherObservation(
  locationName: 'San Francisco',
  minimumTemperatureInCelsius: 7,
  maximumTemperatureInCelsius: 15,
  currentTemperatureInCelsius: 14,
  status: WeatherStatus.lightRain,
);

const locationQueryInput = 'san';

final sanFranciscoSuccessState = WeatherLoadSuccess(
  locationName: 'San Francisco',
  minimumTemperature: 7,
  maximumTemperature: 15,
  currentTemperature: 14,
  status: WeatherStatus.lightCloud,
  updateDate: DateTime.now(),
);

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  setUpAll(setUpHydratedBloc);

  group('WeatherBloc', () {
    late WeatherRepository weatherRepository;
    late LocationSearchBloc locationSearchBloc;
    late TemperatureUnitCubit temperatureUnitCubit;
    late WeatherBloc bloc;
    late StreamController<TemperatureUnit> temperatureUnitStreamController;
    late StreamController<String> locationSearchStreamController;

    setUpAll(() {
      registerLocationSearchBlocFallbackValues();
      registerTemperatureUnitCubitFallbackValues();
    });

    setUp(() {
      weatherRepository = MockWeatherRepository();

      locationSearchStreamController = StreamController();
      locationSearchBloc = MockLocationSearchBloc();
      whenListen(
        locationSearchBloc,
        locationSearchStreamController.stream,
        initialState: '',
      );

      temperatureUnitStreamController = StreamController();
      temperatureUnitCubit = MockTemperatureUnitCubit();
      whenListen(
        temperatureUnitCubit,
        temperatureUnitStreamController.stream,
        initialState: TemperatureUnit.celsius,
      );

      bloc = WeatherBloc(
        weatherRepository: weatherRepository,
        temperatureUnitCubit: temperatureUnitCubit,
        locationSearchBloc: locationSearchBloc,
      );
    });

    tearDown(() {
      temperatureUnitStreamController.close();
      locationSearchStreamController.close();
      bloc.close();
    });

    test('initial state is WeatherInitial', () {
      expect(bloc.state, const WeatherInitial());
    });

    group('WeatherTemperatureUnitChanged', () {
      final successInCelsius = sanFranciscoSuccessState;
      final successInFahrenheit =
          successInCelsius.copyWithToggledTemperatureUnit(
        TemperatureUnit.fahrenheit,
      );

      blocTest<WeatherBloc, WeatherState>(
        'converts WeatherLoadSuccess to Fahrenheit',
        build: () => bloc,
        seed: () => successInCelsius,
        act: (bloc) {
          bloc.add(
            const WeatherTemperatureUnitChanged(TemperatureUnit.fahrenheit),
          );
        },
        expect: () => [successInFahrenheit],
      );

      blocTest<WeatherBloc, WeatherState>(
        'converts WeatherLoadSuccess to Celsius',
        build: () => bloc,
        seed: () => successInFahrenheit,
        act: (bloc) {
          bloc.add(
            const WeatherTemperatureUnitChanged(TemperatureUnit.celsius),
          );
        },
        expect: () => [successInCelsius],
      );

      blocTest<WeatherBloc, WeatherState>(
        'does nothing if state is not WeatherLoadSuccess',
        build: () => bloc,
        seed: () => const WeatherInitial(),
        act: (_) {
          const WeatherTemperatureUnitChanged(TemperatureUnit.fahrenheit);
        },
        expect: () => [],
      );

      blocTest<WeatherBloc, WeatherState>(
        'listens to new TemperatureUnitCubit states',
        build: () => bloc,
        seed: () => successInCelsius,
        act: (_) {
          temperatureUnitStreamController.add(TemperatureUnit.fahrenheit);
        },
        expect: () => [successInFahrenheit],
      );
    });

    group('WeatherNewLocationQueryEntered', () {
      blocTest<WeatherBloc, WeatherState>(
        'emits WeatherLoadSuccess if the repository answers successfully',
        build: () {
          when(
            () => weatherRepository.getWeatherObservation(locationQueryInput),
          ).thenAnswer((_) async => sanFranciscoWeatherObservation);

          return bloc;
        },
        act: (bloc) {
          bloc.add(const WeatherNewLocationQueryEntered(locationQueryInput));
        },
        expect: () => [
          const WeatherLoadInProgress(),
          isA<WeatherLoadSuccess>(),
        ],
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits WeatherLoadFailure if the repository answers with an error',
        build: () {
          when(
            () => weatherRepository.getWeatherObservation(locationQueryInput),
          ).thenAnswer((_) async => throw NoInternetException());
          return bloc;
        },
        act: (bloc) {
          bloc.add(const WeatherNewLocationQueryEntered(locationQueryInput));
        },
        expect: () => [
          const WeatherLoadInProgress(),
          const WeatherLoadFailure(FailureReason.noInternet),
        ],
      );

      blocTest<WeatherBloc, WeatherState>(
        'listens to new LocationSearchBloc states',
        build: () {
          when(
            () => weatherRepository.getWeatherObservation(any()),
          ).thenAnswer(
            (_) async => sanFranciscoWeatherObservation,
          );
          return bloc;
        },
        act: (_) {
          locationSearchStreamController.add('s');
        },
        expect: () => [
          const WeatherLoadInProgress(),
          isA<WeatherLoadSuccess>(),
        ],
      );
    });

    group('WeatherRefreshed', () {
      final previousSuccessState = sanFranciscoSuccessState;
      final previousFailedRefreshSuccessState = previousSuccessState.copyWith(
        failedRefreshDate: DateTime.now(),
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits new WeatherLoadSuccess if the repository answers successfully',
        build: () {
          when(
            () => weatherRepository.getWeatherObservation(any()),
          ).thenAnswer(
            (_) async => sanFranciscoWeatherObservation,
          );

          return bloc;
        },
        seed: () => previousSuccessState,
        act: (bloc) => bloc.add(const WeatherRefreshed()),
        expect: () => [
          // Uses a custom matcher to assert on the [updateDate] property.
          _HasUpdateDate(
            isNot(previousSuccessState.updateDate),
          ),
        ],
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits new WeatherLoadSuccess if the repository answers with an error',
        build: () {
          when(
            () => weatherRepository.getWeatherObservation(locationQueryInput),
          ).thenAnswer((_) async => throw NoInternetException());
          return bloc;
        },
        seed: () => previousSuccessState,
        act: (bloc) => bloc.add(const WeatherRefreshed()),
        expect: () => [
          // Uses custom matchers to assert on [updateDate] and
          // [isFromFailedRefresh].
          allOf(
            _HasUpdateDate(
              previousSuccessState.updateDate,
            ),
            _HasIsFromFailedRefresh(true),
          ),
        ],
      );

      blocTest<WeatherBloc, WeatherState>(
        'two consecutive errors generate two different states',
        build: () {
          when(
            () => weatherRepository.getWeatherObservation(any()),
          ).thenAnswer((_) async => throw NoInternetException());
          return bloc;
        },
        seed: () => previousFailedRefreshSuccessState,
        act: (bloc) => bloc.add(const WeatherRefreshed()),
        expect: () => [isNot(previousFailedRefreshSuccessState)],
      );
    });

    group('WeatherLoadRetried', () {
      blocTest<WeatherBloc, WeatherState>(
        'emits new WeatherLoadSuccess if the repository answers successfully',
        build: () {
          when(() => locationSearchBloc.state).thenReturn(locationQueryInput);
          when(
            () => weatherRepository.getWeatherObservation(locationQueryInput),
          ).thenAnswer(
            (_) async => sanFranciscoWeatherObservation,
          );
          return bloc;
        },
        seed: () => const WeatherLoadFailure(
          FailureReason.unknown,
        ),
        act: (bloc) {
          bloc.add(const WeatherLoadRetried());
        },
        expect: () => [
          const WeatherLoadInProgress(),
          isA<WeatherLoadSuccess>(),
        ],
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits WeatherLoadFailure if the repository answers with an error',
        build: () {
          when(() => locationSearchBloc.state).thenReturn(locationQueryInput);
          when(
            () => weatherRepository.getWeatherObservation(locationQueryInput),
          ).thenAnswer(
            (_) async => throw NoInternetException(),
          );
          return bloc;
        },
        seed: () => const WeatherLoadFailure(
          FailureReason.noInternet,
        ),
        act: (bloc) {
          bloc.add(const WeatherLoadRetried());
        },
        expect: () => [
          const WeatherLoadInProgress(),
          const WeatherLoadFailure(FailureReason.noInternet),
        ],
      );
    });

    group('serialization', () {
      test('returns null if state is not WeatherLoadSuccess', () {
        final originalState = const WeatherLoadFailure(
          FailureReason.unknown,
        );
        final stateJson = bloc.toJson(originalState);
        expect(stateJson, null);
      });

      test('works if state is WeatherLoadSuccess', () {
        final originalState = sanFranciscoSuccessState;
        final serializedState = bloc.toJson(originalState);
        if (serializedState != null) {
          final deserializedState = bloc.fromJson(serializedState);
          expect(
            deserializedState,
            originalState,
          );
        } else {
          throw AssertionError(
            'WeatherBlocTest.toJson should not return null for '
            'WeatherLoadSuccess.',
          );
        }
      });
    });
  });
}

/* Custom WeatherLoadSuccess Matchers */
class _HasUpdateDate extends CustomMatcher {
  _HasUpdateDate(
    matcher,
  ) : super(
          'WeatherLoadSuccess with updateDate that is',
          'updateDate',
          matcher,
        );

  @override
  Object? featureValueOf(actual) => (actual as WeatherLoadSuccess).updateDate;
}

class _HasIsFromFailedRefresh extends CustomMatcher {
  _HasIsFromFailedRefresh(
    matcher,
  ) : super(
          'WeatherLoadSuccess with isFromFailedRefresh that is',
          'isFromFailedRefresh',
          matcher,
        );

  @override
  Object? featureValueOf(actual) =>
      (actual as WeatherLoadSuccess).isFromFailedRefresh;
}
