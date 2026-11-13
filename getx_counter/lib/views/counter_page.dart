import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/counter_controller.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> with WidgetsBindingObserver {
  final c = Get.find<CounterController>();

  @override
  void initState() { super.initState(); WidgetsBinding.instance.addObserver(this); }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      c.pauseTimer();
    }
  }

  @override
  void dispose() { WidgetsBinding.instance.removeObserver(this); super.dispose(); }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: const Text('العداد التفاعلي — GetX'), centerTitle: true),
      body: SafeArea(child: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _counterCard(),
            const SizedBox(height: 18),
            _timerCard(),
            const SizedBox(height: 18),
            const Text('إدارة الحالة باستخدام GetxController و Obx', textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
          ]),
        ),
      ))),
    ),
  );

  Widget _counterCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
      const Icon(Icons.exposure_plus_1_rounded, size: 34, color: Color(0xFF3457D5)),
      const SizedBox(height: 8),
      const Text('قيمة العداد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Obx(() => Text('${c.count.value}', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color(0xFF263F9E)))),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _roundButton(Icons.remove, 'إنقاص', c.decrement),
        const SizedBox(width: 18),
        _roundButton(Icons.add, 'زيادة', c.increment),
      ]),
      const SizedBox(height: 12),
      OutlinedButton.icon(onPressed: c.resetCounter, icon: const Icon(Icons.restart_alt), label: const Text('تصفير العداد')),
    ])),
  );

  Widget _roundButton(IconData icon, String tip, VoidCallback action) => Tooltip(
    message: tip,
    child: FilledButton(onPressed: action, style: FilledButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(18), minimumSize: const Size(58, 58)), child: Icon(icon, size: 27)),
  );

  Widget _timerCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
      const Icon(Icons.timer_outlined, size: 34, color: Color(0xFF008A75)),
      const SizedBox(height: 8),
      const Text('المؤقت الزمني', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Obx(() => Text(c.formattedTime, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 2))),
      const SizedBox(height: 8),
      Obx(() => Chip(
        avatar: Icon(c.isRunning.value ? Icons.play_circle : c.isPaused.value ? Icons.pause_circle : Icons.stop_circle, size: 18),
        label: Text(c.isRunning.value ? 'المؤقت يعمل' : c.isPaused.value ? 'متوقف مؤقتاً' : 'المؤقت متوقف'),
      )),
      const SizedBox(height: 14),
      Wrap(alignment: WrapAlignment.center, spacing: 9, runSpacing: 9, children: [
        Obx(() => FilledButton.icon(onPressed: c.isRunning.value ? null : c.startTimer, icon: const Icon(Icons.play_arrow), label: Text(c.isPaused.value ? 'متابعة' : 'تشغيل'))),
        Obx(() => OutlinedButton.icon(onPressed: c.isRunning.value ? c.pauseTimer : null, icon: const Icon(Icons.pause), label: const Text('إيقاف مؤقت'))),
        OutlinedButton.icon(onPressed: c.stopTimer, icon: const Icon(Icons.stop), label: const Text('إيقاف وتصفير')),
      ]),
    ])),
  );
}
