import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/weather/view/components/weather_status_illustration.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('WeatherStatusIllustration', () {
    testWidgets('sets illustration\'s height to 30% of the screen\'s height',
        (tester) async {
      const screenHeight = 1000.0;
      tester.screenHeight = screenHeight;
      final animationKey = UniqueKey();

      await tester.pumpApp(
        Center(
          child: WeatherStatusIllustration(
            key: animationKey,
            status: WeatherStatus.showers,
          ),
        ),
      );

      final animationFinder = find.byKey(
        animationKey,
      );

      final animationHeight = tester.getSize(animationFinder).height;
      final expectedHeight = 1000 * 0.3;

      expect(animationHeight, expectedHeight);
    });
  });

  group('AnimationAssetNameMapper', () {
    test('maps WeatherStatus.snow to correct asset name', () {
      expect(WeatherStatus.snow.animationAssetName, 'assets/snow.json');
    });

    test('maps WeatherStatus.sleet to correct asset name', () {
      expect(WeatherStatus.sleet.animationAssetName, 'assets/sleet.json');
    });

    test('maps WeatherStatus.hail to correct asset name', () {
      expect(WeatherStatus.hail.animationAssetName, 'assets/hail.json');
    });

    test('maps WeatherStatus.thunderstorm to correct asset name', () {
      expect(WeatherStatus.thunderstorm.animationAssetName,
          'assets/thunderstorm.json');
    });

    test('maps WeatherStatus.heavyRain to correct asset name', () {
      expect(
          WeatherStatus.heavyRain.animationAssetName, 'assets/heavy-rain.json');
    });

    test('maps WeatherStatus.lightRain to correct asset name', () {
      expect(
          WeatherStatus.lightRain.animationAssetName, 'assets/light-rain.json');
    });

    test('maps WeatherStatus.showers to correct asset name', () {
      expect(WeatherStatus.showers.animationAssetName, 'assets/showers.json');
    });

    test('maps WeatherStatus.heavyCloud to correct asset name', () {
      expect(WeatherStatus.heavyCloud.animationAssetName,
          'assets/heavy-cloud.json');
    });

    test('maps WeatherStatus.lightCloud to correct asset name', () {
      expect(WeatherStatus.lightCloud.animationAssetName,
          'assets/light-cloud.json');
    });

    test('maps WeatherStatus.clear to correct asset name', () {
      expect(WeatherStatus.clear.animationAssetName, 'assets/clear.json');
    });
  });
}

extension on WidgetTester {
  set screenHeight(double height) {
    binding.window
      ..devicePixelRatioTestValue = 1.0
      ..physicalSizeTestValue = Size(height / 2, height);
  }
}
