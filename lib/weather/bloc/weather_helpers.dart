part of 'weather_bloc.dart';

extension on double {
  double toPrecision(int fractionDigitCount) {
    final mod = pow(10, fractionDigitCount).toDouble();
    return ((this * mod).round().toDouble() / mod);
  }
}
