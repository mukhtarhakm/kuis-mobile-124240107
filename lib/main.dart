import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kuis_mobile_124240107/views/login.dart';

void main() {
  runApp(const MainApp());
}

// Mengaktifkan fitur geser/drag menggunakan mouse (berguna saat dijalankan di Windows/Chrome/PC)
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
