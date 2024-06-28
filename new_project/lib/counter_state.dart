import 'package:flutter_bloc/flutter_bloc.dart';

class CounterState {
  final int counter;

  CounterState({required this.counter});

  List<Object> get props => [counter];

  factory CounterState.initial() => CounterState(counter: 0);

  CounterState copyWith({int? counter}) =>
      CounterState(counter: counter ?? this.counter);
}

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState.initial());

  void increment() => emit(state.copyWith(counter: state.counter + 1));
  void decrement() => emit(state.copyWith(counter: state.counter - 1));
}
