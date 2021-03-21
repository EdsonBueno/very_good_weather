part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoadInProgress extends WeatherState {
  const WeatherLoadInProgress();
}

class WeatherLoadFailure extends WeatherState {
  const WeatherLoadFailure(
    this.failureReason,
  );

  final FailureReason failureReason;

  @override
  List<Object?> get props => [
        failureReason,
      ];
}

enum FailureReason { noInternet, unknown, locationNotFound }

@JsonSerializable()
class WeatherLoadSuccess extends WeatherState {
  const WeatherLoadSuccess({
    required this.locationName,
    required this.minimumTemperature,
    required this.maximumTemperature,
    required this.currentTemperature,
    required this.status,
    required this.updateDate,
    DateTime? failedRefreshDate,
  }) : _failedRefreshDate = failedRefreshDate;

  final String locationName;

  final double minimumTemperature;

  final double maximumTemperature;

  final double currentTemperature;

  @JsonKey(
    toJson: _convertWeatherStatusToString,
    fromJson: _convertWeatherStatusFromString,
  )
  final WeatherStatus status;

  final DateTime updateDate;

  /// If this state is from a failed refresh, this is the timestamp of the
  /// failure.
  final DateTime? _failedRefreshDate;

  bool get isFromFailedRefresh => _failedRefreshDate != null;

  WeatherLoadSuccess copyWith({
    String? locationName,
    double? minimumTemperature,
    double? maximumTemperature,
    double? currentTemperature,
    WeatherStatus? status,
    DateTime? updateDate,
    // failedRefreshDate can actually be null so we require it to be specified
    required DateTime? failedRefreshDate,
  }) {
    return WeatherLoadSuccess(
      locationName: locationName ?? this.locationName,
      minimumTemperature: minimumTemperature ?? this.minimumTemperature,
      maximumTemperature: maximumTemperature ?? this.maximumTemperature,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      status: status ?? this.status,
      updateDate: updateDate ?? this.updateDate,
      // failedRefreshDate can actually be null
      failedRefreshDate: failedRefreshDate,
    );
  }

  @override
  List<Object?> get props {
    // No need to use more than 2 fraction digits when comparing temperatures.
    const comparisonFractionDigitCount = 2;
    return [
      locationName,
      minimumTemperature.toPrecision(comparisonFractionDigitCount),
      maximumTemperature.toPrecision(comparisonFractionDigitCount),
      currentTemperature.toPrecision(comparisonFractionDigitCount),
      status,
      updateDate,
      _failedRefreshDate,
    ];
  }

  static const fromJson = _$WeatherLoadSuccessFromJson;

  Map<String, dynamic> toJson() => _$WeatherLoadSuccessToJson(this);
}

WeatherStatus _convertWeatherStatusFromString(String value) {
  final weatherStatus = EnumToString.fromString(
    WeatherStatus.values,
    value,
  );

  if (weatherStatus != null) {
    return weatherStatus;
  } else {
    throw ArgumentError('Unknown serialized [WeatherStatus] value.');
  }
}

String _convertWeatherStatusToString(WeatherStatus status) =>
    EnumToString.convertToString(
      status,
    );
