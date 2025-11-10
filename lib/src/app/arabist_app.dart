import 'package:arabist_v2_app/src/app/navigation/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_theme.dart';

class ArabistApp extends StatelessWidget {
  const ArabistApp({super.key});

  @override
  Widget build(BuildContext context) {
     return GetMaterialApp(
      title: 'Arabist v2',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppShell(),
    );
  }
}
