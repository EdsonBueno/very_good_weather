import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/weather/view/components/no_location_selected_indicator.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('NoLocationSelectedIndicator', () {
    testWidgets('uses provided key', (tester) async {
      final key = UniqueKey();

      await tester.pumpApp(
        NoLocationSelectedIndicator(key: key),
      );

      expect(find.byKey(key), findsOneWidget);
    });
  });
}
