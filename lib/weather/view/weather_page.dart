import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_weather/l10n/l10n.dart';
import 'package:very_good_weather/location_search/location_search.dart';
import 'package:very_good_weather/temperature_unit/cubit/temperature_unit_cubit.dart';
import 'package:very_good_weather/weather/bloc/weather_bloc.dart';
import 'package:very_good_weather/weather/view/components/components.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<TemperatureUnitCubit>(
            create: (BuildContext context) => TemperatureUnitCubit(),
          ),
          BlocProvider<LocationSearchBloc>(
            create: (BuildContext context) => LocationSearchBloc(),
          ),
          BlocProvider<WeatherBloc>(
            create: (BuildContext context) => WeatherBloc(
              weatherRepository: context.read<WeatherRepository>(),
              temperatureUnitCubit: context.read<TemperatureUnitCubit>(),
              locationSearchBloc: context.read<LocationSearchBloc>(),
            ),
          ),
        ],
        child: const WeatherView(),
      );
}

class WeatherView extends StatelessWidget {
  const WeatherView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          l10n.weatherAppBarTitle,
        ),
        actions: [
          const WeatherSettingsButton(),
        ],
      ),
      body: GestureDetector(
        onTap: () => _releaseFocus(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const LocationSearchBar(
                key: Key('weatherView_search_locationSearchBar'),
              ),
              const SizedBox(
                height: 16,
              ),
              const Expanded(
                child: WeatherDynamicContent(
                  key: Key('weatherView_content_weatherContent'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}

class WeatherDynamicContent extends StatelessWidget {
  const WeatherDynamicContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocConsumer<WeatherBloc, WeatherState>(
        listenWhen: (previousState, currentState) {
          final isFailedRefresh = currentState is WeatherLoadSuccess &&
              currentState.isFromFailedRefresh;
          return isFailedRefresh;
        },
        listener: (context, state) {
          _showFailedRefreshSnackBar(context);
        },
        builder: (context, state) {
          if (state is WeatherLoadSuccess) {
            return WeatherObservationView(
              weatherObservation: state,
            );
          }

          if (state is WeatherInitial) {
            return const NoLocationSelectedIndicator();
          }

          if (state is WeatherLoadFailure) {
            return WeatherLoadFailureIndicator(
              failureReason: state.failureReason,
            );
          }

          return const CenteredProgressIndicator();
        },
      );

  void _showFailedRefreshSnackBar(BuildContext context) {
    final l10n = context.l10n;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.weatherFailedRefreshAlertMessage),
        ),
      );
  }
}
