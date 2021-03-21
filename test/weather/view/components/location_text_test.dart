import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/weather/view/components/location_text.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('LocationText', () {
    const locationName = 'San Francisco';

    testWidgets('uses provided key', (tester) async {
      final key = UniqueKey();

      await tester.pumpApp(
        LocationText(key: key, text: locationName),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('displays provided text', (tester) async {
      await tester.pumpApp(
        const LocationText(text: locationName),
      );

      expect(find.text(locationName), findsOneWidget);
    });

    testWidgets('displays a pin icon', (tester) async {
      await tester.pumpApp(
        const LocationText(text: locationName),
      );

      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });
  });
}
