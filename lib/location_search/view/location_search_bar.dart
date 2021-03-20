import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_weather/l10n/l10n.dart';
import 'package:very_good_weather/location_search/bloc/location_search_bloc.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextField(
      key: const Key('locationSearchBar_search_textField'),
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.search),
        hintText: l10n.weatherLocationSearchBarHint,
        labelText: l10n.weatherLocationSearchBarLabel,
      ),
      onChanged: (input) {
        context.read<LocationSearchBloc>().add(
              LocationSearchInputChanged(
                input,
              ),
            );
      },
    );
  }
}
