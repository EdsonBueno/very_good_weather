import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_weather/location_search/bloc/location_search_bloc.dart';
import 'package:very_good_weather/models/temperature_unit.dart';
import 'package:very_good_weather/temperature_unit/cubit/temperature_unit_cubit.dart';

class MockTemperatureUnitCubit extends MockCubit<TemperatureUnit>
    implements TemperatureUnitCubit {}

void registerTemperatureUnitCubitFallbackValues() {
  registerFallbackValue<TemperatureUnit>(
    TemperatureUnit.celsius,
  );
}

class MockStorage extends Mock implements Storage {}

void setUpHydratedBloc({MockStorage? mockStorage}) {
  TestWidgetsFlutterBinding.ensureInitialized();
  final hydratedBlocStorage = mockStorage ?? MockStorage();
  when(() => hydratedBlocStorage.write(any(), any<dynamic>()))
      .thenAnswer((_) async {});
  HydratedBloc.storage = hydratedBlocStorage;
}

class MockLocationSearchBloc
    extends MockBloc<LocationSearchInputChanged, String>
    implements LocationSearchBloc {}

void registerLocationSearchBlocFallbackValues() {
  registerFallbackValue<LocationSearchInputChanged>(
    LocationSearchInputChanged(''),
  );
}
