import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_repository/weather_repository.dart';

/// Displays an animated illustration representing [status].
class WeatherStatusIllustration extends StatelessWidget {
  const WeatherStatusIllustration({
    Key? key,
    required this.status,
    this.shouldAnimate = true,
  }) : super(key: key);

  final bool shouldAnimate;
  final WeatherStatus status;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final animationHeight = screenHeight * 0.3;
    return Lottie.asset(
      status.animationAssetName,
      height: animationHeight,
      animate: shouldAnimate,
    );
  }
}

extension AnimationAssetNameMapper on WeatherStatus {
  String get animationAssetName {
    switch (this) {
      case WeatherStatus.snow:
        return 'assets/snow.json';
      case WeatherStatus.sleet:
        return 'assets/sleet.json';
      case WeatherStatus.hail:
        return 'assets/hail.json';
      case WeatherStatus.thunderstorm:
        return 'assets/thunderstorm.json';
      case WeatherStatus.heavyRain:
        return 'assets/heavy-rain.json';
      case WeatherStatus.lightRain:
        return 'assets/light-rain.json';
      case WeatherStatus.showers:
        return 'assets/showers.json';
      case WeatherStatus.heavyCloud:
        return 'assets/heavy-cloud.json';
      case WeatherStatus.lightCloud:
        return 'assets/light-cloud.json';
      default:
        return 'assets/clear.json';
    }
  }
}
