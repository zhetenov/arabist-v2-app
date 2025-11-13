import 'dart:math';
import 'package:flutter/material.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/database/database_helper.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final db = DatabaseHelper();
  List<WordModel> words = [];
  final Map<int, List<String>> _optionsCache = {};
  int currentIndex = 0;
  bool isLoading = true;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final favs = await db.loadFavorites();
    if (favs.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    final allWords = await db
        .loadAllWords();
    final allKazakh = allWords
        .map((e) => e.kazakh ?? '')
        .where((e) => e.isNotEmpty)
        .toList();

    favs.shuffle();
    final quizWords = favs.take(10).toList();
    final random = Random();

    for (var i = 0; i < quizWords.length; i++) {
      final current = quizWords[i].kazakh ?? '';
      final options = <String>{current};

      final source = allKazakh.length >= 4
          ? allKazakh
          : favs.map((e) => e.kazakh ?? '').toList();

      while (options.length < 4 && source.isNotEmpty) {
        options.add(source[random.nextInt(source.length)]);
      }

      _optionsCache[i] = options.toList()..shuffle();
    }

    setState(() {
      words = quizWords;
      isLoading = false;
    });
  }

  void _checkAnswer(String selected) {
    final currentWord = words[currentIndex];
    final correct = selected.trim() == (currentWord.kazakh ?? '').trim();

    setState(() => isCorrect = correct);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      if (currentIndex < words.length - 1) {
        setState(() {
          currentIndex++;
          isCorrect = null;
        });
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    if (!mounted) return;

    final parentContext = context;

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFF1a2036),
        title: const Text('Аяқталды!', style: TextStyle(color: Colors.white)),
        content: Text(
          'Сіз ${words.length} сөзді қайталадыңыз.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              Navigator.of(parentContext).pop();
            },
            child: const Text('OK', style: TextStyle(color: Color(0xFFF5C851))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0F2B),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFF5C851)),
        ),
      );
    }

    if (words.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0F2B),
        body: Center(
          child: Text(
            'Таңдаулы сөздер жоқ',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final currentWord = words[currentIndex];
    final options = _optionsCache[currentIndex]!;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F2B),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Сөз ${currentIndex + 1}/${words.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              currentWord.arabic ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFF5C851),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ...options.map(
              (opt) => GestureDetector(
                onTap: () => _checkAnswer(opt),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isCorrect == null
                        ? const Color(0xFF1a2036)
                        : (opt == (currentWord.kazakh ?? '')
                              ? Colors.green[700]
                              : Colors.red[700]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    opt,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
