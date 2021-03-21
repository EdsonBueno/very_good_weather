import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/app/app.dart';
import 'package:very_good_weather/weather/view/weather_page.dart';

import 'helpers/helpers.dart';

void main() {
  setUpAll(setUpHydratedBloc);

  group('App', () {
    testWidgets('renders WeatherPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(WeatherPage), findsOneWidget);
    });
  });
}
