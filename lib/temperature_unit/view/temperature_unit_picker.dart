import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_weather/l10n/l10n.dart';
import 'package:very_good_weather/models/temperature_unit.dart';
import 'package:very_good_weather/temperature_unit/cubit/temperature_unit_cubit.dart';

class TemperatureUnitPicker extends StatelessWidget {
  const TemperatureUnitPicker({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final TemperatureUnitCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.temperatureUnitPickerTitle),
      content: BlocProvider.value(
        value: cubit,
        child: _OptionListView(),
      ),
      contentPadding: const EdgeInsets.only(top: 20),
      actions: [
        TextButton(
          key: const Key('temperatureUnitPicker_cancel_textButton'),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(l10n.temperatureUnitPickerCancelAction.toUpperCase()),
        ),
      ],
    );
  }
}

class _OptionListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TemperatureUnitCubit, TemperatureUnit>(
        builder: (context, selectedOption) {
          final options = TemperatureUnit.values;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (option) => option.toSelectionOptionWidget(
                    context,
                    selectedOption,
                  ),
                )
                .toList(),
          );
        },
      );
}

extension on TemperatureUnit {
  Widget toSelectionOptionWidget(
    BuildContext context,
    TemperatureUnit selectedUnit,
  ) =>
      RadioListTile<TemperatureUnit>(
        key: _toUniqueKey(),
        title: Text(
          _toRadioTitle(context),
        ),
        value: this,
        groupValue: selectedUnit,
        onChanged: (newUnit) {
          context.read<TemperatureUnitCubit>().toggle();
          Navigator.of(context).pop();
        },
      );

  Key _toUniqueKey() => Key(
        'temperatureUnitPicker_'
        '${this == TemperatureUnit.fahrenheit ? 'fahrenheit' : 'celsius'}'
        '_radioListTile',
      );

  String _toRadioTitle(BuildContext context) {
    final l10n = context.l10n;
    if (this == TemperatureUnit.celsius) {
      return l10n.celsiusTemperatureUnitPickerOption;
    } else {
      return l10n.fahrenheitTemperatureUnitPickerOption;
    }
  }
}
