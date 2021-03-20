import 'package:test/test.dart';
import 'package:weather_repository/src/remote/meta_weather_api_url_builder.dart';

void main() {
  group('MetaWeatherApiUrlBuilder', () {
    const baseUrl = 'https://www.metaweather.com/api/location';

    late MetaWeatherApiUrlBuilder urlBuilder;

    setUp(() {
      urlBuilder = MetaWeatherApiUrlBuilder(baseUrl: baseUrl);
    });

    test('buildGetLocationUrl returns the correct URL', () {
      const query = 'san';

      final url = urlBuilder.buildGetLocationUrl(query);

      expect(url, '$baseUrl/search/?query=$query');
    });

    test('buildGet5DayWeatherReportUrl returns the correct URL', () {
      const locationId = 85943;

      final url = urlBuilder.buildGet5DayWeatherReportUrl(locationId);

      expect(url, '$baseUrl/$locationId');
    });
  });
}
