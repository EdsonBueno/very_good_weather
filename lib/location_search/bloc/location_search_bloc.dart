import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'location_search_event.dart';

class LocationSearchBloc extends Bloc<LocationSearchInputChanged, String> {
  LocationSearchBloc() : super('');

  @override
  Stream<Transition<LocationSearchInputChanged, String>> transformEvents(
    Stream<LocationSearchInputChanged> events,
    TransitionFunction<LocationSearchInputChanged, String> transitionFn,
  ) {
    return super.transformEvents(
      events
          .debounceTime(
            const Duration(seconds: 1),
          )
          .where(
            (event) => event.newInput.isNotEmpty,
          ),
      transitionFn,
    );
  }

  @override
  Stream<String> mapEventToState(LocationSearchInputChanged event) async* {
    yield event.newInput;
  }
}
