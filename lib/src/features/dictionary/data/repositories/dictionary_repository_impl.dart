import 'package:arabist_v2_app/src/core/db/app_database.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';

class DictionaryRepositoryImpl {
  Future<List<WordModel>> searchWords(String query) async {
    final db = await AppDatabase.instance();

    final results = await db.query(
      'words',
      where: 'arabic LIKE ? OR kazakh LIKE ? OR russian LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );

    return results.map((e) => WordModel.fromMap(e)).toList();
  }

  Future<void> insertWord(WordModel word) async {
    final db = await AppDatabase.instance();
    await db.insert('words', word.toMap());
  }
}
