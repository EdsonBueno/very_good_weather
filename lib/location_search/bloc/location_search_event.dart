part of 'location_search_bloc.dart';

class LocationSearchInputChanged extends Equatable {
  LocationSearchInputChanged(this.newInput);

  final String newInput;

  @override
  List<Object?> get props => [newInput];
}
