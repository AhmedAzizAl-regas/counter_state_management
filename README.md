# 📱 واجب الأسبوع الثالث — تطبيق العداد وإدارة الحالة

<p align="center">
  <b>تطبيق واحد بوظيفتين متطابقتين في نسختين مستقلتين</b><br>
  <sub>Flutter · Dart · GetX 4.x · Riverpod 2.x</sub>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white">
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white">
  <img src="https://img.shields.io/badge/GetX-4.x-8A2BE2">
  <img src="https://img.shields.io/badge/Riverpod-2.x-00A67E">
  <img src="https://img.shields.io/badge/RTL-Arabic-success">
</p>

## ✨ نبذة
إعادة تنفيذ تطبيق العداد التفاعلي مرتين بالوظائف والتصميم نفسيهما، للمقارنة بين إدارة الحالة باستخدام **GetX** وإدارة الحالة باستخدام **Modern Riverpod 2.x**. كل مجلد يمثل مشروع Flutter مستقل قابل للتشغيل.

## 🎯 الوظائف
- زيادة العداد وإنقاصه (لا يسمح بالنزول تحت الصفر).
- تصفير العداد.
- مؤقت يحسب الوقت بالثواني ويعرضه بصيغة `MM:SS`.
- تشغيل، إيقاف مؤقت، متابعة، وإيقاف مع تصفير المؤقت.
- إظهار حالة المؤقت بوضوح.
- مراقبة دورة حياة التطبيق: إيقاف المؤقت مؤقتاً عند الانتقال للخلفية أو فقدان التركيز، وعدم تشغيله تلقائياً عند العودة.
- واجهة عربية RTL ومتجاوبة باستخدام Material 3.

## 🗂️ هيكل المشروع
```text
week3_counter_state_management/
├── README.md
├── getx_counter/
│   ├── pubspec.yaml
│   └── lib/
│       ├── main.dart
│       ├── controllers/counter_controller.dart
│       └── views/counter_page.dart
└── riverpod_counter/
    ├── pubspec.yaml
    └── lib/
        ├── main.dart
        ├── models/counter_state.dart
        ├── providers/counter_provider.dart
        └── views/counter_page.dart
```

## 🚀 التشغيل

### نسخة GetX
```bash
cd getx_counter
flutter pub get
flutter run
```

### نسخة Riverpod 2.x
```bash
cd riverpod_counter
flutter pub get
flutter run
```
> افتح مجلد النسخة المطلوبة في VS Code أو Android Studio. لا تنفذ الأوامر من المجلد الرئيسي؛ كل نسخة لها `pubspec.yaml` مستقل.

## 🧠 شرح إدارة الحالة

### GetX
- `CounterController` يرث من `GetxController`.
- الحالة التفاعلية تستخدم `RxInt` و`RxBool`.
- `Obx` يستمع للقيم ويعيد بناء عناصر الواجهة المتأثرة فقط.
- `Timer.periodic` مسؤول عن تحديث الثواني.
- `onClose()` يلغي المؤقت ويحرر المورد عند التخلص من المتحكم.

### Riverpod 2.x
- `CounterState` كائن حالة immutable.
- `CounterNotifier` يرث من `StateNotifier<CounterState>`.
- `StateNotifierProvider` يربط الحالة بالواجهة.
- الشاشة تستخدم `ConsumerStatefulWidget` (وهو ConsumerWidget مع دعم lifecycle عبر Stateful) وتقرأ الحالة بواسطة `ref.watch`، وتنفذ الأوامر بواسطة `ref.read`.
- `dispose()` يلغي المؤقت عند التخلص من Notifier.

## 🔄 تحليل دورة حياة التطبيق

تستخدم النسختان `WidgetsBindingObserver` لمراقبة `AppLifecycleState`.

| الحالة | السلوك |
|---|---|
| `resumed` | عاد التطبيق للواجهة؛ لا يبدأ المؤقت تلقائياً |
| `inactive` | إيقاف مؤقت |
| `hidden` | إيقاف مؤقت |
| `paused` | إيقاف مؤقت |
| `detached` | إيقاف مؤقت |

يتم الاحتفاظ بقيمة العداد والزمن الذي وصل إليه المؤقت. عند العودة إلى التطبيق يستطيع المستخدم الضغط على **متابعة** لاستكمال العد من القيمة السابقة.

## ⚖️ مقارنة سريعة

| العنصر | GetX | Riverpod 2.x |
|---|---|---|
| إدارة الحالة | `GetxController` | `StateNotifier` |
| تحديث الواجهة | `Obx` | `Consumer` / `ref.watch` |
| الوصول للحالة | Rx variables | `StateNotifierProvider` |
| تحرير المؤقت | `onClose()` | `dispose()` |

## 🧪 خطوات الاختبار
1. زد العداد مرتين ثم أنقصه مرة.
2. صفّر العداد وتأكد من عودته إلى صفر.
3. شغّل المؤقت وانتظر 5 ثوانٍ تقريباً.
4. اضغط إيقاف مؤقت وانتظر؛ يجب ألا تتغير القيمة.
5. اضغط متابعة ثم إيقاف وتصفير.
6. شغّل المؤقت وانتقل إلى تطبيق آخر أو الشاشة الرئيسية.
7. ارجع للتطبيق؛ يجب أن يظهر المؤقت متوقفاً مؤقتاً وألا يعمل تلقائياً.
8. كرر الخطوات نفسها في النسخة الثانية.

## 📦 الحزم
- GetX: `get: ^4.6.6`
- Riverpod: `flutter_riverpod: ^2.6.1`
- Flutter SDK فقط لبقية الوظائف.

## ℹ️ ملاحظات
- لا يحتاج التطبيق إلى خادم أو قاعدة بيانات.
- المؤقت تعليمي ويعمل أثناء وجود التطبيق في الواجهة فقط.
- النسختان متطابقتان في السلوك والوظائف، والاختلاف في طريقة إدارة الحالة.
- صور التطبيق غير مرفقة حتى لا نضع لقطات شكلية غير حقيقية؛ يمكن رفع Screenshots فعلية من المحاكي إلى المستودع.

---
<p align="center">واجب الأسبوع الثالث — Flutter State Management</p>
