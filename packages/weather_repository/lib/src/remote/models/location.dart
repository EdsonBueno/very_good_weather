import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  Location({
    required this.id,
    required this.name,
  });

  @JsonKey(name: 'woeid')
  final int id;

  @JsonKey(name: 'title')
  final String name;

  static const fromJson = _$LocationFromJson;
}
