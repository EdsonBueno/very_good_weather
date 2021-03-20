import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/location_search/bloc/location_search_bloc.dart';
import 'package:very_good_weather/location_search/view/location_search_bar.dart';

import '../../helpers/helpers.dart';

void main() {
  setUpAll(registerLocationSearchBlocFallbackValues);

  group('LocationSearchBar', () {
    late LocationSearchBloc bloc;

    setUp(() {
      bloc = MockLocationSearchBloc();
    });

    testWidgets('uses provided key', (tester) async {
      final key = UniqueKey();

      await tester.pumpLocationSearchBar(
        bloc: bloc,
        key: key,
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('adds LocationSearchInputChanged to the bloc on enter text',
        (tester) async {
      await tester.pumpLocationSearchBar(
        bloc: bloc,
      );

      const inputText = 'san';
      await tester.enterText(
        find.byKey(
          const Key('locationSearchBar_search_textField'),
        ),
        inputText,
      );

      verify(
        () => bloc.add(
          LocationSearchInputChanged(inputText),
        ),
      ).called(1);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpLocationSearchBar({
    required LocationSearchBloc bloc,
    Key? key,
  }) {
    return pumpApp(
      BlocProvider.value(
        value: bloc,
        child: Material(
          child: LocationSearchBar(
            key: key,
          ),
        ),
      ),
    );
  }
}
