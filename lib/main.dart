// lib/main.dart
import "package:flutter/material.dart";
import 'core/routes/app_router.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
