import 'dart:io';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'arabic_utils.dart';

class DatabaseHelper {
  static Database? _database;
  static const int currentVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, 'arabist.db');

    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt('db_version') ?? 0;

    if (currentVersion > storedVersion || !(await File(path).exists())) {
      if (await File(path).exists()) {
        await deleteDatabase(path);
      }

      final ByteData data = await rootBundle.load('assets/db/arabist.db');
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(path).writeAsBytes(bytes, flush: true);

      await prefs.setInt('db_version', currentVersion);
    }

    return openDatabase(path);
  }

  Future<List<WordModel>> translateWord(String word) async {
    if (word.trim().isEmpty) return [];

    final normalized = word.trim().toLowerCase();
    final bool arabic = isArabic(normalized);

    print('Searching: "$normalized" (arabic=$arabic)');
    List<WordModel> result = [];

    if (arabic) {
      result = await loadKazakhWordsWithArabic(normalized);

      if (result.isEmpty) {
        final simplified = replaceArabicLettersToEasyArabicLetters(
          getArabicLetters(normalized),
        );
        if (simplified != null && simplified.isNotEmpty) {
          result = await loadKazakhWordsWithArabic2(simplified);
        }
      }
    } else {
      result = await loadKazakhWordsWithKazakhSimilarWord(normalized);
      if (result.isEmpty) {
        result = await loadKazakhWordsWithDescriptionSimilar(normalized);
        if (result.isEmpty) {
          result = await loadKazakhWordsByDescription(normalized);
        }
      }
    }

    return result;
  }

  Future<List<WordModel>> loadKazakhWordsWithArabic(String arabic) async {
    final db = await database;
    final res = await db.query(
      'kazakh',
      where: 'arabic = ?',
      whereArgs: [arabic],
    );
    return res.map(WordModel.fromMap).toList();
  }

  Future<List<WordModel>> loadKazakhWordsWithArabic2(String arabic) async {
    final db = await database;
    const sql = '''
      SELECT DISTINCT * FROM (
        SELECT *, 1 AS order_prefix FROM kazakh WHERE search = ? 
        UNION ALL 
        SELECT *, 2 AS order_prefix FROM kazakh WHERE plural_letters = ?
      )
      ORDER BY order_prefix LIMIT 100
    ''';
    final res = await db.rawQuery(sql, [arabic, arabic]);
    return res.map(WordModel.fromMap).toList();
  }

  Future<List<WordModel>> loadKazakhWordsWithKazakhSimilarWord(
    String word,
  ) async {
    final db = await database;
    const sql = '''
      SELECT DISTINCT * FROM (
        SELECT *, 1 AS order_prefix FROM kazakh WHERE lower(kazakh) = ? 
        UNION ALL 
        SELECT *, 2 AS order_prefix FROM kazakh WHERE short_words LIKE '% ' || ? || ' %'
        UNION ALL 
        SELECT *, 3 AS order_prefix FROM kazakh WHERE long_words LIKE '%' || ? || '%'
      ) AS combined_results 
      ORDER BY order_prefix 
      LIMIT 100
    ''';
    final res = await db.rawQuery(sql, [word, word, word]);
    return res.map(WordModel.fromMap).toList();
  }

  Future<List<WordModel>> loadKazakhWordsWithDescriptionSimilar(
    String word,
  ) async {
    final db = await database;
    const sql =
        'SELECT * FROM kazakh WHERE lower(kazakh) LIKE "%" || ? || "%" LIMIT 100';
    final res = await db.rawQuery(sql, [word]);
    return res.map(WordModel.fromMap).toList();
  }

  Future<List<WordModel>> loadKazakhWordsByDescription(String word) async {
    final db = await database;
    const sql =
        'SELECT * FROM kazakh WHERE lower(description) LIKE "%" || ? || "%" LIMIT 100';
    final res = await db.rawQuery(sql, [word]);
    return res.map(WordModel.fromMap).toList();
  }

  Future<List<WordModel>> loadRoots(int root, int myId) async {
    final db = await database;
    final res = await db.query(
      'kazakh',
      where: 'root_id = ? AND id != ?',
      whereArgs: [root, myId],
    );
    return res.map(WordModel.fromMap).toList();
  }

  Future<int> updateFavorite(int wordId, bool isFavorite) async {
    try {
      final db = await database;
      final result = await db.rawUpdate(
        'UPDATE kazakh SET is_chosen = ? WHERE id = ?',
        [isFavorite ? 1 : 0, wordId],
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WordModel>> loadFavorites() async {
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM kazakh WHERE is_chosen = 1');
    return res.map(WordModel.fromMap).toList();
  }

  Future<List<WordModel>> loadAllWords() async {
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM kazakh LIMIT 50');
    return res.map(WordModel.fromMap).toList();
  }

  Future<void> updateHistory(int wordId) async {
    final db = await database;
    final viewedAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    await db.rawUpdate('UPDATE kazakh SET viewed_at = ? WHERE id = ?', [
      viewedAt,
      wordId,
    ]);
  }

  Future<void> updateViewedAt(int wordId) async {
    final db = await database;
    await db.update(
      'kazakh',
      {'viewed_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [wordId],
    );
  }

  Future<List<WordModel>> loadHistory() async {
    final db = await database;
    final res = await db.rawQuery(
      'SELECT * FROM kazakh WHERE viewed_at IS NOT NULL ORDER BY viewed_at DESC LIMIT 10',
    );
    return res.map(WordModel.fromMap).toList();
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.rawUpdate('UPDATE kazakh SET viewed_at = NULL');
  }

  Future<WordModel?> getWordById(int id) async {
    try {
      final db = await database;
      final maps = await db.query('kazakh', where: 'id = ?', whereArgs: [id]);

      if (maps.isNotEmpty) {
        final word = WordModel.fromMap(maps.first);
        return word;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
