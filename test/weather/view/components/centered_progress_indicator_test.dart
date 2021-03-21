import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/weather/view/components/centered_progress_indicator.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('CenteredProgressIndicator', () {
    testWidgets('uses provided key', (tester) async {
      final key = UniqueKey();

      await tester.pumpApp(
        CenteredProgressIndicator(key: key),
      );

      expect(find.byKey(key), findsOneWidget);
    });
  });
}
