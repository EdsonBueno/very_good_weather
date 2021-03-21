import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_weather/temperature_unit/cubit/temperature_unit_cubit.dart';
import 'package:very_good_weather/temperature_unit/view/temperature_unit_picker.dart';

class WeatherSettingsButton extends StatelessWidget {
  const WeatherSettingsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.settings,
      ),
      onPressed: () {
        _showTemperatureUnitPicker(context);
      },
    );
  }

  void _showTemperatureUnitPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => TemperatureUnitPicker(
        cubit: context.read<TemperatureUnitCubit>(),
      ),
    );
  }
}
