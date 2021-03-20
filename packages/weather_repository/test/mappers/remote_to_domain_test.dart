import 'package:test/test.dart';
import 'package:weather_repository/src/mappers/remote_to_domain.dart';
import 'package:weather_repository/src/models/models.dart';
import 'package:weather_repository/src/remote/models/daily_weather.dart';

void main() {
  group('DailyWeatherToCurrentWeather', () {
    group('toWeatherObservation', () {
      test('maps DailyWeather to WeatherObservation correctly', () {
        final remoteItems = [
          DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 'sn',
          ),
          DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 'sl',
          ),
          DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 'h',
          ),
          DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 't',
          ),
          DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 'hr',
          ),
          DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 'lr',
          ),
          DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 's',
          ),
          DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 'hc',
          ),
          DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 'lc',
          ),
          DailyWeather(
            minimumTemperatureInCelsius: 1.0,
            maximumTemperatureInCelsius: 2.0,
            currentTemperatureInCelsius: 3.0,
            statusAbbreviation: 'c',
          ),
        ];

        const locationName = 'San Francisco';

        final mappedItems = remoteItems
            .map(
              (dailyWeather) => dailyWeather.toWeatherObservation(locationName),
            )
            .toList();

        final expectedMappedItems = remoteItems
            .mapIndexed(
              (index, dailyWeather) => WeatherObservation(
                locationName: locationName,
                minimumTemperatureInCelsius:
                    dailyWeather.minimumTemperatureInCelsius,
                maximumTemperatureInCelsius:
                    dailyWeather.maximumTemperatureInCelsius,
                currentTemperatureInCelsius:
                    dailyWeather.currentTemperatureInCelsius,
                status: WeatherStatus.values[index],
              ),
            )
            .toList();

        expect(mappedItems, expectedMappedItems);
      });

      test('throws UnknownWeatherStateException for unknown statusAbbreviation',
          () {
        final dailyWeather = DailyWeather(
          minimumTemperatureInCelsius: 1.0,
          maximumTemperatureInCelsius: 2.0,
          currentTemperatureInCelsius: 3.0,
          statusAbbreviation: 'ab',
        );

        expect(
          () => dailyWeather.toWeatherObservation('San Francisco'),
          throwsA(
            isA<UnknownWeatherStateException>(),
          ),
        );
      });
    });
  });
}

extension IterableUtils<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E e) f) sync* {
    var index = 0;

    for (final item in this) {
      yield f(index, item);
      index = index + 1;
    }
  }
}
