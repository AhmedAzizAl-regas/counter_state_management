import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/counter_state.dart';

final counterProvider = StateNotifierProvider<CounterNotifier, CounterState>((ref) => CounterNotifier());

class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(const CounterState());
  Timer? _timer;

  void increment() => state = state.copyWith(count: state.count + 1);
  void decrement() { if (state.count > 0) state = state.copyWith(count: state.count - 1); }
  void resetCounter() => state = state.copyWith(count: 0);

  void startTimer() {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true, isPaused: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }

  void pauseTimer() {
    if (!state.isRunning) return;
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false, isPaused: true);
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(elapsedSeconds: 0, isRunning: false, isPaused: false);
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
}
