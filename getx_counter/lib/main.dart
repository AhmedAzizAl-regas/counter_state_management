import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/counter_controller.dart';
import 'views/counter_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(CounterController());
  runApp(const GetXCounterApp());
}

class GetXCounterApp extends StatelessWidget {
  const GetXCounterApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'عداد GetX',
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3457D5)), scaffoldBackgroundColor: const Color(0xFFF4F6FB)),
    home: const CounterPage(),
  );
}
