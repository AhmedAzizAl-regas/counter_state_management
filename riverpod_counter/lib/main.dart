import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/counter_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: RiverpodCounterApp()));
}

class RiverpodCounterApp extends StatelessWidget {
  const RiverpodCounterApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'عداد Riverpod',
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3457D5)), scaffoldBackgroundColor: const Color(0xFFF4F6FB)),
    home: const CounterPage(),
  );
}
