import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_weather/location_search/bloc/location_search_bloc.dart';

void main() {
  group('LocationSearchBloc', () {
    late LocationSearchBloc bloc;

    setUp(() {
      bloc = LocationSearchBloc();
    });

    test('initial state is an empty string', () {
      expect(bloc.state, '');
    });

    blocTest<LocationSearchBloc, String>(
      'debounces LocationSearchInputChanged events',
      build: () => bloc,
      act: (cubit) => bloc.add(LocationSearchInputChanged('a')),
      expect: () => [],
    );

    blocTest<LocationSearchBloc, String>(
      'handles LocationSearchInputChanged events after debounce time',
      build: () => bloc,
      wait: const Duration(seconds: 1),
      act: (cubit) => bloc.add(LocationSearchInputChanged('a')),
      expect: () => ['a'],
    );

    blocTest<LocationSearchBloc, String>(
      'ignores LocationSearchInputChanged events with an empty String',
      build: () => bloc,
      wait: const Duration(seconds: 1),
      act: (cubit) => bloc.add(LocationSearchInputChanged('')),
      expect: () => [],
    );
  });
}
