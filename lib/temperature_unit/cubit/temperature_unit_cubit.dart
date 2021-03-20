import 'package:enum_to_string/enum_to_string.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:very_good_weather/models/temperature_unit.dart';

class TemperatureUnitCubit extends HydratedCubit<TemperatureUnit> {
  TemperatureUnitCubit() : super(TemperatureUnit.celsius);

  static const _temperatureUnitJsonKey = 'temperature-unit';

  void toggle() {
    final oldUnit = state;
    final newUnit = oldUnit == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
    emit(newUnit);
  }

  @override
  TemperatureUnit? fromJson(Map<String, dynamic> json) =>
      EnumToString.fromString(
        TemperatureUnit.values,
        json[_temperatureUnitJsonKey],
      );

  @override
  Map<String, dynamic> toJson(TemperatureUnit state) => {
        _temperatureUnitJsonKey: EnumToString.convertToString(state),
      };
}
