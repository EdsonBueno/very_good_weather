import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/weather/bloc/weather_bloc.dart';
import 'package:very_good_weather/weather/view/components/components.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('WeatherObservationView', () {
    final weatherObservation = WeatherLoadSuccess(
      locationName: 'San Francisco',
      minimumTemperature: -2,
      maximumTemperature: 2,
      currentTemperature: 0,
      status: WeatherStatus.heavyRain,
      updateDate: DateTime.now(),
    );

    late WeatherBloc bloc;

    setUpAll(registerWeatherBlocFallbackValues);

    setUp(() {
      bloc = MockWeatherBloc();
    });

    testWidgets('uses provided key', (tester) async {
      final key = UniqueKey();

      await tester.pumpWeatherObservationView(
        bloc: bloc,
        weatherObservation: weatherObservation,
        key: key,
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('adds WeatherRefreshed event to the bloc on pull to refresh',
        (tester) async {
      when(() => bloc.stream).thenAnswer(
        (_) => Stream.fromIterable([weatherObservation]),
      );
      await tester.pumpWeatherObservationView(
        bloc: bloc,
        weatherObservation: weatherObservation,
      );

      await tester.fling(
        find.byType(WeatherStatusIllustration),
        const Offset(0.0, 500.0),
        1000,
      );

      await tester.pumpAndSettle();

      verify(
        () => bloc.add(const WeatherRefreshed()),
      ).called(1);
    });

    group('displays correctly formatted', () {
      testWidgets('last update date', (tester) async {
        await tester.pumpWeatherObservationView(
          bloc: bloc,
          weatherObservation: weatherObservation,
        );

        final updateDate = weatherObservation.updateDate;
        final date = DateFormat.yMd().format(updateDate);
        final time = DateFormat.Hm().format(updateDate);

        final formattedLastUpdateDateLine = 'Last updated on $date at $time';

        expect(find.text(formattedLastUpdateDateLine), findsOneWidget);
      });

      testWidgets('current temperature', (tester) async {
        await tester.pumpWeatherObservationView(
          bloc: bloc,
          weatherObservation: weatherObservation,
        );

        final roundedCurrentTemperature =
            weatherObservation.currentTemperature.round();
        final formattedCurrentTemperature = '$roundedCurrentTemperature°';

        expect(find.text(formattedCurrentTemperature), findsOneWidget);
      });

      testWidgets('minimum and maximum temperatures', (tester) async {
        await tester.pumpWeatherObservationView(
          bloc: bloc,
          weatherObservation: weatherObservation,
        );

        final roundedMinTemperature =
            weatherObservation.minimumTemperature.round();
        final roundedMaxTemperature =
            weatherObservation.maximumTemperature.round();

        final formattedMinAndMaxTemperature =
            '$roundedMinTemperature°/$roundedMaxTemperature°';

        expect(find.text(formattedMinAndMaxTemperature), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpWeatherObservationView({
    required WeatherBloc bloc,
    required WeatherLoadSuccess weatherObservation,
    Key? key,
  }) =>
      pumpApp(
        BlocProvider.value(
          value: bloc,
          child: WeatherObservationView(
            key: key,
            weatherObservation: weatherObservation,
            shouldAnimateIllustration: false,
          ),
        ),
      );
}
