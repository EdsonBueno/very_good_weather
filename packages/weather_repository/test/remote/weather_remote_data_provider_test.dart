import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:weather_repository/src/remote/weather_remote_data_provider.dart';

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

void main() {
  group('WeatherRemoteDataProvider', () {
    late Dio dio;
    late WeatherRemoteDataProvider remoteDataProvider;
    late Response response;

    setUp(() {
      dio = MockDio();
      remoteDataProvider = WeatherRemoteDataProvider(dio: dio);
      response = MockResponse();
      when(() => dio.get(any())).thenAnswer((_) async => response);
    });

    test('instantiates without needing a Dio instance', () {
      expect(WeatherRemoteDataProvider(), isNotNull);
    });

    group('searchLocation', () {
      test(
          'throws EmptySearchResultException if the response is an empty array',
          () {
        when(() => response.data).thenReturn([]);

        expect(
          () async => await remoteDataProvider.searchLocation('Chicago'),
          throwsA(isA<EmptySearchResultException>()),
        );
      });

      test('returns the first location in the API response', () async {
        const mostLikelyLocationName = 'San Francisco';
        const responseJsonArray = [
          {
            'title': mostLikelyLocationName,
            'location_type': 'City',
            'woeid': 2487956,
            'latt_long': '37.777119, -122.41964'
          },
          {
            'title': 'San Diego',
            'location_type': 'City',
            'woeid': 2487889,
            'latt_long': '32.715691,-117.161720'
          },
          {
            'title': 'San Jose',
            'location_type': 'City',
            'woeid': 2488042,
            'latt_long': '37.338581,-121.885567'
          },
        ];

        when(() => response.data).thenReturn(responseJsonArray);

        final location = await remoteDataProvider.searchLocation('san');

        expect(location.name, mostLikelyLocationName);
      });
    });

    group('getCurrentWeather', () {
      test('returns the first daily weather in the API response', () async {
        const firstItemCurrentTemperatureInCelsius = 11.46;
        const responseJson = {
          'consolidated_weather': [
            {
              'id': 5913272134926336,
              'weather_state_name': 'Heavy Rain',
              'weather_state_abbr': 'hr',
              'wind_direction_compass': 'SSE',
              'created': '2021-03-18T15:20:15.688395Z',
              'applicable_date': '2021-03-18',
              'min_temp': 8.735,
              'max_temp': 11.815,
              'the_temp': 11.46,
              'wind_speed': 8.184398608133831,
              'wind_direction': 164.82254088579026,
              'air_pressure': 1019.0,
              'humidity': 88,
              'visibility': 5.682750238606538,
              'predictability': 77
            },
            {
              'id': 4658398319607808,
              'weather_state_name': 'Heavy Cloud',
              'weather_state_abbr': 'hc',
              'wind_direction_compass': 'W',
              'created': '2021-03-18T15:20:18.797294Z',
              'applicable_date': '2021-03-19',
              'min_temp': 9.095,
              'max_temp': 12.920000000000002,
              'the_temp': 13.469999999999999,
              'wind_speed': 5.215726634412365,
              'wind_direction': 274.0008130560872,
              'air_pressure': 1023.0,
              'humidity': 69,
              'visibility': 14.456200787401574,
              'predictability': 71
            },
            {
              'id': 5307084208865280,
              'weather_state_name': 'Clear',
              'weather_state_abbr': 'c',
              'wind_direction_compass': 'WNW',
              'created': '2021-03-18T15:20:21.680780Z',
              'applicable_date': '2021-03-20',
              'min_temp': 7.695,
              'max_temp': 12.004999999999999,
              'the_temp': 12.405000000000001,
              'wind_speed': 8.075635732564491,
              'wind_direction': 294.4970224418615,
              'air_pressure': 1026.5,
              'humidity': 66,
              'visibility': 14.10295126461465,
              'predictability': 68
            },
            {
              'id': 4729856408420352,
              'weather_state_name': 'Light Cloud',
              'weather_state_abbr': 'lc',
              'wind_direction_compass': 'WNW',
              'created': '2021-03-18T15:20:24.611716Z',
              'applicable_date': '2021-03-21',
              'min_temp': 6.995,
              'max_temp': 12.735,
              'the_temp': 13.614999999999998,
              'wind_speed': 7.571125035398605,
              'wind_direction': 294.4011396936093,
              'air_pressure': 1024.0,
              'humidity': 64,
              'visibility': 15.269575678040244,
              'predictability': 70
            },
            {
              'id': 5041874810175488,
              'weather_state_name': 'Clear',
              'weather_state_abbr': 'c',
              'wind_direction_compass': 'WNW',
              'created': '2021-03-18T15:20:28.703677Z',
              'applicable_date': '2021-03-22',
              'min_temp': 8.129999999999999,
              'max_temp': 12.350000000000001,
              'the_temp': 13.99,
              'wind_speed': 10.818304893409158,
              'wind_direction': 299.96602419811734,
              'air_pressure': 1023.0,
              'humidity': 74,
              'visibility': 14.432899367692675,
              'predictability': 68
            },
            {
              'id': 5153753809289216,
              'weather_state_name': 'Clear',
              'weather_state_abbr': 'c',
              'wind_direction_compass': 'WNW',
              'created': '2021-03-18T15:20:30.745874Z',
              'applicable_date': '2021-03-23',
              'min_temp': 8.955,
              'max_temp': 16.025,
              'the_temp': 14.39,
              'wind_speed': 5.781476179113975,
              'wind_direction': 303.0,
              'air_pressure': 1020.0,
              'humidity': 65,
              'visibility': 9.999726596675416,
              'predictability': 68
            }
          ],
          'time': '2021-03-18T09:22:13.087117-07:00',
          'sun_rise': '2021-03-18T07:15:38.266595-07:00',
          'sun_set': '2021-03-18T19:19:10.821567-07:00',
          'timezone_name': 'LMT',
          'parent': {
            'title': 'California',
            'location_type': 'Region / State / Province',
            'woeid': 2347563,
            'latt_long': '37.271881,-119.270233'
          },
          'sources': [
            {
              'title': 'BBC',
              'slug': 'bbc',
              'url': 'http://www.bbc.co.uk/weather/',
              'crawl_rate': 360
            },
          ],
          'title': 'San Francisco',
          'location_type': 'City',
          'woeid': 2487956,
          'latt_long': '37.777119, -122.41964',
          'timezone': 'US/Pacific'
        };

        when(() => response.data).thenReturn(responseJson);

        final currentWeather = await remoteDataProvider.getCurrentWeather(
          2487956,
        );

        expect(
          currentWeather.currentTemperatureInCelsius,
          firstItemCurrentTemperatureInCelsius,
        );
      });
    });
  });
}
