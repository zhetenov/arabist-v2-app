import 'package:arabist_v2_app/src/features/dictionary/cubit/search_cubit.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/database/database_helper.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/app/arabist_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Если будет база, SharedPreferences, и т.д. — можно инициализировать тут
  // await AppInitializer.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchCubit(DictionaryRepositoryImpl(DatabaseHelper()))),
      ],
      child: const ArabistApp(),
    ),
  );
}
