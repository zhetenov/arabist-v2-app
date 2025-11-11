import 'package:arabist_v2_app/src/features/dictionary/data/database/database_helper.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';

class DictionaryRepositoryImpl {
  final DatabaseHelper _dbHelper;

  DictionaryRepositoryImpl(this._dbHelper);

  Future<List<WordModel>> search(String query) async {
    return _dbHelper.translateWord(query);
  }

  Future<void> toggleFavorite(int wordId, bool isFavorite) async {
    await _dbHelper.updateFavorite(wordId, isFavorite);
  }

  Future<List<WordModel>> getFavorites() async {
    return _dbHelper.loadFavorites();
  }

  Future<void> updateHistory(int wordId) async {
    await _dbHelper.updateHistory(wordId);
  }

  Future<List<WordModel>> getHistory() async {
    return _dbHelper.loadHistory();
  }
}
