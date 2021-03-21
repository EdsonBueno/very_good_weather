import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/weather/view/components/weather_status_localized_description.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('WeatherStatusLocalizedDescription', () {
    testWidgets('uses provided key', (tester) async {
      final key = UniqueKey();

      await tester.pumpWeatherStatusLocalizedDescription(
        key: key,
        status: WeatherStatus.snow,
      );

      expect(find.byKey(key), findsOneWidget);
    });

    group('displays correct description', () {
      testWidgets('for WeatherStatus.snow', (tester) async {
        await tester.expectDescriptionForStatus(
          expectedDescription: 'Snow',
          status: WeatherStatus.snow,
        );
      });

      testWidgets('for WeatherStatus.sleet', (tester) async {
        await tester.expectDescriptionForStatus(
          expectedDescription: 'Sleet',
          status: WeatherStatus.sleet,
        );
      });

      testWidgets('for WeatherStatus.hail', (tester) async {
        await tester.expectDescriptionForStatus(
          expectedDescription: 'Hail',
          status: WeatherStatus.hail,
        );
      });

      testWidgets('for WeatherStatus.thunderstorm', (tester) async {
        await tester.expectDescriptionForStatus(
          expectedDescription: 'Thunderstorm',
          status: WeatherStatus.thunderstorm,
        );
      });

      testWidgets('for WeatherStatus.heavyRain', (tester) async {
        await tester.expectDescriptionForStatus(
          expectedDescription: 'Heavy Rain',
          status: WeatherStatus.heavyRain,
        );
      });

      testWidgets('for WeatherStatus.lightRain', (tester) async {
        await tester.expectDescriptionForStatus(
          expectedDescription: 'Light Rain',
          status: WeatherStatus.lightRain,
        );
      });

      testWidgets('for WeatherStatus.showers', (tester) async {
        await tester.expectDescriptionForStatus(
          expectedDescription: 'Showers',
          status: WeatherStatus.showers,
        );
      });

      testWidgets('for WeatherStatus.heavyCloud', (tester) async {
        await tester.expectDescriptionForStatus(
          expectedDescription: 'Heavy Cloud',
          status: WeatherStatus.heavyCloud,
        );
      });

      testWidgets('for WeatherStatus.lightCloud', (tester) async {
        await tester.expectDescriptionForStatus(
          expectedDescription: 'Light Cloud',
          status: WeatherStatus.lightCloud,
        );
      });

      testWidgets('for WeatherStatus.clear', (tester) async {
        await tester.expectDescriptionForStatus(
          expectedDescription: 'Clear',
          status: WeatherStatus.clear,
        );
      });
    });
  });
}

extension on WidgetTester {
  Future<void> expectDescriptionForStatus({
    required String expectedDescription,
    required WeatherStatus status,
  }) async {
    await pumpWeatherStatusLocalizedDescription(
      status: status,
    );

    expect(find.text(expectedDescription), findsOneWidget);
  }

  Future<void> pumpWeatherStatusLocalizedDescription({
    required WeatherStatus status,
    Key? key,
  }) {
    return pumpApp(
      WeatherStatusLocalizedDescription(
        key: key,
        status: status,
      ),
    );
  }
}
