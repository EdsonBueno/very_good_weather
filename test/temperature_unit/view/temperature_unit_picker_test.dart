import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/models/temperature_unit.dart';
import 'package:very_good_weather/temperature_unit/cubit/temperature_unit_cubit.dart';
import 'package:very_good_weather/temperature_unit/view/temperature_unit_picker.dart';

import '../../helpers/helpers.dart';

void main() {
  setUpAll(registerTemperatureUnitCubitFallbackValues);

  group('TemperatureUnitPicker', () {
    final fahrenheitRadioKey = const Key(
      'temperatureUnitPicker_fahrenheit_radioListTile',
    );

    late TemperatureUnitCubit cubit;

    setUp(() {
      cubit = MockTemperatureUnitCubit();
    });

    testWidgets('is dismissed on button tap', (tester) async {
      when(() => cubit.state).thenReturn(
        TemperatureUnit.celsius,
      );

      final pickerKey = UniqueKey();

      await tester.pumpApp(
        TemperatureUnitPicker(
          key: pickerKey,
          cubit: cubit,
        ),
      );

      await tester.tap(
        find.byKey(
          const Key('temperatureUnitPicker_cancel_textButton'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(pickerKey), findsNothing);
    });

    testWidgets('gets selected value from cubit', (tester) async {
      when(() => cubit.state).thenReturn(
        TemperatureUnit.fahrenheit,
      );

      final pickerKey = UniqueKey();

      await tester.pumpApp(
        TemperatureUnitPicker(
          key: pickerKey,
          cubit: cubit,
        ),
      );

      await tester.tap(find.byKey(fahrenheitRadioKey));

      await tester.pumpAndSettle();

      // Nothing happens when an already selected radio is tapped.
      expect(find.byKey(pickerKey), findsOneWidget);
    });

    testWidgets('is dismissed on unit change', (tester) async {
      when(() => cubit.state).thenReturn(
        TemperatureUnit.celsius,
      );

      final pickerKey = UniqueKey();

      await tester.pumpApp(
        TemperatureUnitPicker(
          key: pickerKey,
          cubit: cubit,
        ),
      );

      await tester.tap(find.byKey(fahrenheitRadioKey));
      await tester.pumpAndSettle();

      expect(find.byKey(pickerKey), findsNothing);
    });

    testWidgets('calls toggle on cubit when the unit changes', (tester) async {
      when(() => cubit.state).thenReturn(
        TemperatureUnit.celsius,
      );

      final pickerKey = UniqueKey();

      await tester.pumpApp(
        TemperatureUnitPicker(
          key: pickerKey,
          cubit: cubit,
        ),
      );

      await tester.tap(find.byKey(fahrenheitRadioKey));

      verify(
        () => cubit.toggle(),
      ).called(1);
    });
  });
}
