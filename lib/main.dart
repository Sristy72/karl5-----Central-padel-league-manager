import 'package:flutter/material.dart';
import 'package:flutter_karlfive223_manager/features/auth/presentation/screens/splash_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'core/init/app_initializer.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() async {
  await AppInitializer.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override

  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KarlFive Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: SplashScreen(),
    );
  }
}
