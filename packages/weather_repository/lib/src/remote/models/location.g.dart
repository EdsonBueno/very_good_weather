// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return $checkedNew('Location', json, () {
    final val = Location(
      id: $checkedConvert(json, 'woeid', (v) => v as int),
      name: $checkedConvert(json, 'title', (v) => v as String),
    );
    return val;
  }, fieldKeyMap: const {'id': 'woeid', 'name': 'title'});
}
