class MetaWeatherApiUrlBuilder {
  MetaWeatherApiUrlBuilder({
    String? baseUrl,
  }) : _baseUrl = baseUrl ?? 'https://www.metaweather.com/api/location';

  final String _baseUrl;

  String buildGetLocationUrl(String query) => '$_baseUrl/search/?query=$query';

  String buildGet5DayWeatherReportUrl(int locationId) =>
      '$_baseUrl/$locationId';
}
