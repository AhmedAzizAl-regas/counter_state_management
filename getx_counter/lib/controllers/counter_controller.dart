import 'dart:async';
import 'package:get/get.dart';

class CounterController extends GetxController {
  final count = 0.obs;
  final elapsedSeconds = 0.obs;
  final isRunning = false.obs;
  final isPaused = false.obs;
  Timer? _timer;

  void increment() => count.value++;
  void decrement() { if (count.value > 0) count.value--; }
  void resetCounter() => count.value = 0;

  void startTimer() {
    if (isRunning.value) return;
    isRunning.value = true;
    isPaused.value = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => elapsedSeconds.value++);
  }

  void pauseTimer() {
    if (!isRunning.value) return;
    _timer?.cancel();
    _timer = null;
    isRunning.value = false;
    isPaused.value = true;
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    elapsedSeconds.value = 0;
    isRunning.value = false;
    isPaused.value = false;
  }

  String get formattedTime {
    final m = elapsedSeconds.value ~/ 60;
    final s = elapsedSeconds.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() { _timer?.cancel(); super.onClose(); }
}
