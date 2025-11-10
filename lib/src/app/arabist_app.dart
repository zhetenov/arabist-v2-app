import 'package:arabist_v2_app/src/features/dictionary/presentation/pages/dictionary_page.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';

class ArabistApp extends StatelessWidget {
  const ArabistApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'Arabist v2',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DictionaryPage(),
    );
  }
}
