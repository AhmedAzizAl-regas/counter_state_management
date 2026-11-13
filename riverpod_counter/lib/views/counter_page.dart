import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/counter_provider.dart';

class CounterPage extends ConsumerStatefulWidget {
  const CounterPage({super.key});
  @override
  ConsumerState<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends ConsumerState<CounterPage> with WidgetsBindingObserver {
  @override
  void initState() { super.initState(); WidgetsBinding.instance.addObserver(this); }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      ref.read(counterProvider.notifier).pauseTimer();
    }
  }

  @override
  void dispose() { WidgetsBinding.instance.removeObserver(this); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(counterProvider);
    final actions = ref.read(counterProvider.notifier);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('العداد التفاعلي — Riverpod'), centerTitle: true),
        body: SafeArea(child: Center(child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              _counterCard(state.count, actions),
              const SizedBox(height: 18),
              _timerCard(state, actions),
              const SizedBox(height: 18),
              const Text('إدارة الحالة باستخدام StateNotifier و ConsumerWidget', textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
            ]),
          ),
        ))),
      ),
    );
  }

  Widget _counterCard(int count, CounterNotifier actions) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
      const Icon(Icons.exposure_plus_1_rounded, size: 34, color: Color(0xFF3457D5)),
      const SizedBox(height: 8),
      const Text('قيمة العداد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Text('$count', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color(0xFF263F9E))),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _roundButton(Icons.remove, 'إنقاص', actions.decrement),
        const SizedBox(width: 18),
        _roundButton(Icons.add, 'زيادة', actions.increment),
      ]),
      const SizedBox(height: 12),
      OutlinedButton.icon(onPressed: actions.resetCounter, icon: const Icon(Icons.restart_alt), label: const Text('تصفير العداد')),
    ])),
  );

  Widget _roundButton(IconData icon, String tip, VoidCallback action) => Tooltip(
    message: tip,
    child: FilledButton(onPressed: action, style: FilledButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(18), minimumSize: const Size(58, 58)), child: Icon(icon, size: 27)),
  );

  Widget _timerCard(CounterState state, CounterNotifier actions) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
      const Icon(Icons.timer_outlined, size: 34, color: Color(0xFF008A75)),
      const SizedBox(height: 8),
      const Text('المؤقت الزمني', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Text(state.formattedTime, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 2)),
      const SizedBox(height: 8),
      Chip(
        avatar: Icon(state.isRunning ? Icons.play_circle : state.isPaused ? Icons.pause_circle : Icons.stop_circle, size: 18),
        label: Text(state.isRunning ? 'المؤقت يعمل' : state.isPaused ? 'متوقف مؤقتاً' : 'المؤقت متوقف'),
      ),
      const SizedBox(height: 14),
      Wrap(alignment: WrapAlignment.center, spacing: 9, runSpacing: 9, children: [
        FilledButton.icon(onPressed: state.isRunning ? null : actions.startTimer, icon: const Icon(Icons.play_arrow), label: Text(state.isPaused ? 'متابعة' : 'تشغيل')),
        OutlinedButton.icon(onPressed: state.isRunning ? actions.pauseTimer : null, icon: const Icon(Icons.pause), label: const Text('إيقاف مؤقت')),
        OutlinedButton.icon(onPressed: actions.stopTimer, icon: const Icon(Icons.stop), label: const Text('إيقاف وتصفير')),
      ]),
    ])),
  );
}
