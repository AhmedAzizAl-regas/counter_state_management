class CounterState {
  final int count;
  final int elapsedSeconds;
  final bool isRunning;
  final bool isPaused;

  const CounterState({this.count = 0, this.elapsedSeconds = 0, this.isRunning = false, this.isPaused = false});

  CounterState copyWith({int? count, int? elapsedSeconds, bool? isRunning, bool? isPaused}) => CounterState(
    count: count ?? this.count,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    isRunning: isRunning ?? this.isRunning,
    isPaused: isPaused ?? this.isPaused,
  );

  String get formattedTime {
    final m = elapsedSeconds ~/ 60;
    final s = elapsedSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
