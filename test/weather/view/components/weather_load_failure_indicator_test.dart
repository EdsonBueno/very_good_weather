import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/weather/bloc/weather_bloc.dart';
import 'package:very_good_weather/weather/view/components/weather_load_failure_indicator.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('WeatherLoadFailureIndicator', () {
    const tryAgainButtonKey = Key(
      'weatherLoadFailureIndicator_tryAgain_elevatedButton',
    );

    testWidgets('uses provided key', (tester) async {
      final key = UniqueKey();

      await tester.pumpApp(
        WeatherLoadFailureIndicator(
          failureReason: FailureReason.noInternet,
          key: key,
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('adds "try again" when failureReason is noInternet',
        (tester) async {
      await tester.pumpApp(
        const WeatherLoadFailureIndicator(
          failureReason: FailureReason.noInternet,
        ),
      );

      expect(find.byKey(tryAgainButtonKey), findsOneWidget);
    });

    testWidgets('adds "try again" when failureReason is unknown',
        (tester) async {
      await tester.pumpApp(
        const WeatherLoadFailureIndicator(
          failureReason: FailureReason.unknown,
        ),
      );

      expect(find.byKey(tryAgainButtonKey), findsOneWidget);
    });

    testWidgets(
        'does not add "try again" when failureReason is locationNotFound',
        (tester) async {
      await tester.pumpApp(
        const WeatherLoadFailureIndicator(
          failureReason: FailureReason.locationNotFound,
        ),
      );

      expect(find.byKey(tryAgainButtonKey), findsNothing);
    });

    testWidgets('adds WeatherLoadRetried to bloc on "try again" tap',
        (tester) async {
      registerWeatherBlocFallbackValues();
      final bloc = MockWeatherBloc();
      await tester.pumpApp(
        BlocProvider<WeatherBloc>.value(
          value: bloc,
          child: const WeatherLoadFailureIndicator(
            failureReason: FailureReason.noInternet,
          ),
        ),
      );

      await tester.tap(find.byKey(tryAgainButtonKey));

      verify(
        () => bloc.add(const WeatherLoadRetried()),
      ).called(1);
    });

    group('displays', () {
      testWidgets('correct noInternet localized description', (tester) async {
        await tester.pumpApp(
          const WeatherLoadFailureIndicator(
            failureReason: FailureReason.noInternet,
          ),
        );

        const descriptionText = 'It looks like you don\'t have '
            'internet access. Please check your connection and try again.';

        expect(find.text(descriptionText), findsOneWidget);
      });

      testWidgets('correct unknown localized description', (tester) async {
        await tester.pumpApp(
          const WeatherLoadFailureIndicator(
            failureReason: FailureReason.unknown,
          ),
        );

        const descriptionText = 'An unknown error occurred. '
            'Please try again later.';

        expect(find.text(descriptionText), findsOneWidget);
      });

      testWidgets('correct locationNotFound localized description',
          (tester) async {
        await tester.pumpApp(
          const WeatherLoadFailureIndicator(
            failureReason: FailureReason.locationNotFound,
          ),
        );

        const descriptionText = 'We couldn\'t find a location for '
            'the entered text.';

        expect(find.text(descriptionText), findsOneWidget);
      });
    });
  });
}
