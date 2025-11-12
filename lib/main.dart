// lib/main.dart
import 'package:flutter/material.dart';
import 'core/app_router.dart';
import 'core/theme/app_theme.dart'; // ✅ 추가

void main() {
  debugProfileBuildsEnabled = true;
  debugPrintRebuildDirtyWidgets = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Search',
      theme: appTheme, // ✅ 커스텀 테마 적용
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
