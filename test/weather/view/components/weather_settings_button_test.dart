import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/models/temperature_unit.dart';
import 'package:very_good_weather/temperature_unit/temperature_unit.dart';
import 'package:very_good_weather/weather/view/components/weather_settings_button.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('WeatherSettingsButton', () {
    registerTemperatureUnitCubitFallbackValues();

    testWidgets('opens TemperatureUnitPicker on tap', (tester) async {
      final buttonKey = UniqueKey();
      final cubit = MockTemperatureUnitCubit();

      when(() => cubit.state).thenReturn(
        TemperatureUnit.celsius,
      );

      await tester.pumpApp(
        Material(
          child: BlocProvider<TemperatureUnitCubit>.value(
            value: cubit,
            child: WeatherSettingsButton(
              key: buttonKey,
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(buttonKey),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TemperatureUnitPicker), findsOneWidget);
    });
  });
}
