// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherLoadSuccess _$WeatherLoadSuccessFromJson(Map<String, dynamic> json) {
  return WeatherLoadSuccess(
    locationName: json['locationName'] as String,
    minimumTemperature: (json['minimumTemperature'] as num).toDouble(),
    maximumTemperature: (json['maximumTemperature'] as num).toDouble(),
    currentTemperature: (json['currentTemperature'] as num).toDouble(),
    status: _convertWeatherStatusFromString(json['status'] as String),
    updateDate: DateTime.parse(json['updateDate'] as String),
  );
}

Map<String, dynamic> _$WeatherLoadSuccessToJson(WeatherLoadSuccess instance) =>
    <String, dynamic>{
      'locationName': instance.locationName,
      'minimumTemperature': instance.minimumTemperature,
      'maximumTemperature': instance.maximumTemperature,
      'currentTemperature': instance.currentTemperature,
      'status': _convertWeatherStatusToString(instance.status),
      'updateDate': instance.updateDate.toIso8601String(),
    };
