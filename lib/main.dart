import 'package:flutter/material.dart';
import 'src/app/arabist_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Если будет база, SharedPreferences, и т.д. — можно инициализировать тут
  // await AppInitializer.init();

  runApp(const ArabistApp());
}
