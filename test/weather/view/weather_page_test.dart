import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/weather/weather.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/helpers.dart';

class _MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late MockWeatherBloc mockBloc;
  late MockStorage mockStorage;

  setUpAll(() {
    mockStorage = MockStorage();
    registerWeatherBlocFallbackValues();
    setUpHydratedBloc(mockStorage: mockStorage);
  });

  setUp(() {
    mockBloc = MockWeatherBloc();
    when(() => mockBloc.state).thenReturn(
      const WeatherInitial(),
    );
  });

  group('WeatherPage', () {
    testWidgets('uses provided key', (tester) async {
      final key = UniqueKey();

      await tester.pumpWeatherPage(key: key);

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders WeatherView', (tester) async {
      await tester.pumpWeatherPage();
      expect(find.byType(WeatherView), findsOneWidget);
    });
  });

  group('WeatherView', () {
    testWidgets('uses provided key', (tester) async {
      final key = UniqueKey();

      await tester.pumpWeatherView(
        key: key,
        mockBloc: mockBloc,
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('releases search bar focus on tap outside', (tester) async {
      final key = UniqueKey();

      await tester.pumpWeatherView(
        key: key,
        mockBloc: mockBloc,
      );

      final searchBarFinder = find.byKey(
        const Key('weatherView_search_locationSearchBar'),
      );

      await tester.tap(searchBarFinder);

      final searchBarScope = FocusScope.of(
        tester.element(searchBarFinder),
      );

      await tester.tap(
        find.byKey(
          const Key('weatherView_content_weatherContent'),
        ),
      );

      final isSearchBarFocused = searchBarScope.hasFocus;

      expect(isSearchBarFocused, false);
    });

    testWidgets('matches golden file for WeatherLoadSuccess', (tester) async {
      final successState = WeatherLoadSuccess(
        locationName: 'San Francisco',
        minimumTemperature: -2,
        maximumTemperature: 2,
        currentTemperature: 0,
        status: WeatherStatus.heavyRain,
        updateDate: DateTime.now(),
      );

      await tester.expectWeatherViewMatchesGoldenFileForState(
        state: successState,
        goldenFileName: 'goldens/weather-load-success.png',
        mockBloc: mockBloc,
      );
    });

    testWidgets('matches golden file for WeatherInitial', (tester) async {
      await tester.expectWeatherViewMatchesGoldenFileForState(
        state: const WeatherInitial(),
        goldenFileName: 'goldens/weather-initial.png',
        mockBloc: mockBloc,
      );
    });

    testWidgets('matches golden file for WeatherLoadInProgress',
        (tester) async {
      await tester.expectWeatherViewMatchesGoldenFileForState(
        state: const WeatherLoadInProgress(),
        goldenFileName: 'goldens/weather-load-in-progress.png',
        mockBloc: mockBloc,
      );
    });

    testWidgets('matches golden file for WeatherLoadFailure with noInternet',
        (tester) async {
      await tester.expectWeatherViewMatchesGoldenFileForState(
        state: const WeatherLoadFailure(FailureReason.noInternet),
        goldenFileName: 'goldens/weather-load-failure-no-internet.png',
        mockBloc: mockBloc,
      );
    });

    testWidgets('matches golden file for WeatherLoadFailure with unknown',
        (tester) async {
      await tester.expectWeatherViewMatchesGoldenFileForState(
        state: const WeatherLoadFailure(FailureReason.unknown),
        goldenFileName: 'goldens/weather-load-failure-unknown.png',
        mockBloc: mockBloc,
      );
    });

    testWidgets(
        'matches golden file for WeatherLoadFailure with locationNotFound',
        (tester) async {
      await tester.expectWeatherViewMatchesGoldenFileForState(
        state: const WeatherLoadFailure(FailureReason.locationNotFound),
        goldenFileName: 'goldens/weather-load-failure-location-not-found.png',
        mockBloc: mockBloc,
      );
    });
  });

  group('WeatherDynamicContent', () {
    testWidgets('uses provided key', (tester) async {
      final key = UniqueKey();

      await tester.pumpWeatherDynamicContent(
        bloc: mockBloc,
        key: key,
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('displays WeatherObservationView for WeatherLoadSuccess state',
        (tester) async {
      final successState = WeatherLoadSuccess(
        locationName: 'San Francisco',
        minimumTemperature: -2,
        maximumTemperature: 2,
        currentTemperature: 0,
        status: WeatherStatus.heavyRain,
        updateDate: DateTime.now(),
      );

      await tester.expectWidgetForState(
        widgetType: WeatherObservationView,
        state: successState,
        mockBloc: mockBloc,
      );
    });

    testWidgets('displays NoLocationSelectedIndicator for WeatherInitial state',
        (tester) async {
      await tester.expectWidgetForState(
        widgetType: NoLocationSelectedIndicator,
        state: const WeatherInitial(),
        mockBloc: mockBloc,
      );
    });

    testWidgets(
        'displays WeatherLoadFailureIndicator for WeatherLoadFailure state',
        (tester) async {
      await tester.expectWidgetForState(
        widgetType: WeatherLoadFailureIndicator,
        state: const WeatherLoadFailure(
          FailureReason.noInternet,
        ),
        mockBloc: mockBloc,
      );
    });

    testWidgets(
        'displays CenteredProgressIndicator for WeatherLoadInProgress state',
        (tester) async {
      await tester.expectWidgetForState(
        widgetType: CenteredProgressIndicator,
        state: const WeatherLoadInProgress(),
        mockBloc: mockBloc,
      );
    });

    testWidgets(
        'displays a Snackbar if WeatherLoadSuccess came from a failed refresh',
        (tester) async {
      final successState = WeatherLoadSuccess(
        locationName: 'San Francisco',
        minimumTemperature: 2,
        maximumTemperature: 4,
        currentTemperature: 3,
        status: WeatherStatus.heavyRain,
        updateDate: DateTime.now().subtract(const Duration(minutes: 15)),
        failedRefreshDate: DateTime.now(),
      );

      whenListen(
        mockBloc,
        Stream.fromIterable([
          const WeatherInitial(),
          successState,
        ]),
      );

      await tester.pumpWeatherDynamicContent(bloc: mockBloc);

      await tester.pump();

      expect(
        find.byType(SnackBar),
        findsOneWidget,
      );
    });

    testWidgets('displays restored bloc state', (tester) async {
      registerLocationSearchBlocFallbackValues();
      registerTemperatureUnitCubitFallbackValues();

      when<dynamic>(
        () => mockStorage.read(any()),
      ).thenReturn(
        WeatherLoadSuccess(
          locationName: 'San Francisco',
          minimumTemperature: 7,
          maximumTemperature: 15,
          currentTemperature: 14,
          status: WeatherStatus.lightCloud,
          updateDate: DateTime.now(),
        ).toJson(),
      );

      await tester.pumpWeatherDynamicContent(
        bloc: WeatherBloc(
          locationSearchBloc: MockLocationSearchBloc(),
          temperatureUnitCubit: MockTemperatureUnitCubit(),
          weatherRepository: _MockWeatherRepository(),
        ),
      );

      expect(find.byType(WeatherObservationView), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> expectWidgetForState({
    required Type widgetType,
    required WeatherState state,
    required MockWeatherBloc mockBloc,
  }) async {
    when(() => mockBloc.state).thenReturn(
      state,
    );

    await pumpWeatherDynamicContent(bloc: mockBloc);

    expect(find.byType(widgetType), findsOneWidget);
  }

  Future<void> pumpWeatherDynamicContent({
    required WeatherBloc bloc,
    Key? key,
  }) {
    return pumpApp(
      BlocProvider.value(
        value: bloc,
        child: Scaffold(
          body: WeatherDynamicContent(
            key: key,
          ),
        ),
      ),
    );
  }

  Future<void> pumpWeatherPage({
    Key? key,
  }) {
    return pumpApp(
      RepositoryProvider<WeatherRepository>.value(
        value: _MockWeatherRepository(),
        child: WeatherPage(
          key: key,
        ),
      ),
    );
  }

  Future<void> pumpWeatherView({
    required MockWeatherBloc mockBloc,
    Key? key,
  }) {
    return pumpApp(
      BlocProvider<WeatherBloc>.value(
        value: mockBloc,
        child: WeatherView(
          key: key,
        ),
      ),
    );
  }

  Future<void> expectWeatherViewMatchesGoldenFileForState({
    required WeatherState state,
    required String goldenFileName,
    required MockWeatherBloc mockBloc,
  }) async {
    when(() => mockBloc.state).thenReturn(
      state,
    );

    await pumpWeatherView(mockBloc: mockBloc);

    await expectLater(
      find.byType(WeatherView),
      matchesGoldenFile(goldenFileName),
    );
  }
}
