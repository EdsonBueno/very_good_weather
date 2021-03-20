import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/models/temperature_unit.dart';
import 'package:very_good_weather/temperature_unit/cubit/temperature_unit_cubit.dart';

import '../../helpers/bloc_mock_helpers.dart';

void main() {
  group('TemperatureUnitCubit', () {
    late TemperatureUnitCubit cubit;

    setUpAll(setUpHydratedBloc);

    setUp(() {
      cubit = TemperatureUnitCubit();
    });

    test('initial state is TemperatureUnit.celsius', () {
      expect(cubit.state, TemperatureUnit.celsius);
    });

    test('serialization/deserialization works', () {
      final originalState = cubit.state;
      final stateJson = cubit.toJson(originalState);
      final deserializedState = cubit.fromJson(stateJson);
      expect(
        deserializedState,
        originalState,
      );
    });

    blocTest<TemperatureUnitCubit, TemperatureUnit>(
      'changes to TemperatureUnit.fahrenheit when toggle is called',
      build: () => cubit,
      seed: () => TemperatureUnit.celsius,
      act: (cubit) => cubit.toggle(),
      expect: () => [TemperatureUnit.fahrenheit],
    );

    blocTest<TemperatureUnitCubit, TemperatureUnit>(
      'changes back to TemperatureUnit.celsius when toggle is called twice',
      build: () => cubit,
      seed: () => TemperatureUnit.fahrenheit,
      act: (cubit) => cubit.toggle(),
      expect: () => [TemperatureUnit.celsius],
    );
  });
}
