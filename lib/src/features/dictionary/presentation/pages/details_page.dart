import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:arabist_v2_app/src/features/dictionary/data/database/database_helper.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/widgets/word_list_widget.dart';

class DetailsPage extends StatefulWidget {
  final WordModel word;

  const DetailsPage({super.key, required this.word});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late WordModel word;
  List<WordModel> rootWords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    word = widget.word;
    _loadRoots();
  }

  Future<void> _loadRoots() async {
    setState(() => isLoading = true);
    final db = DatabaseHelper();
    final roots = await db.loadRoots(word.rootId ?? 0, word.id);
    setState(() {
      rootWords = roots;
      isLoading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    final updated = !word.isChosen;
    await DatabaseHelper().updateFavorite(word.id, updated);
    setState(() => word = word.copyWith(isChosen: updated));
  }

  Future<void> _copyToClipboard() async {
    final text =
        '${word.arabic ?? ''}\n${word.kazakh ?? ''}\n${word.description ?? ''}';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  bool _isArabic(String text) {
    if (text.isEmpty) return false;
    final code = text.codeUnitAt(0);
    return code >= 0x0600 && code <= 0x06FF;
  }

  @override
  Widget build(BuildContext context) {
    final title = word.arabic?.isNotEmpty == true
        ? word.arabic!
        : (word.kazakh ?? 'Толық ақпарат');

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F2B),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
          textDirection:
              _isArabic(title) ? TextDirection.rtl : TextDirection.ltr,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              word.isChosen ? Icons.star : Icons.star_border_outlined,
              color: const Color(0xFFF5C851),
              size: 24,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Word Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a2036),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            word.arabic ?? '',
                            style: const TextStyle(
                              color: Color(0xFFF5C851),
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              word.arabicSecond ?? '',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color(0xFFb7b7b7),
                                fontSize: 27,
                                fontWeight: FontWeight.w400,
                                height: 1.1,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0x33FFFFFF), thickness: 1),
                    const SizedBox(height: 10),
                    Text(
                      word.kazakh ?? word.description ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            color: Color(0xFF3de0d0),
                            size: 24,
                          ),
                          onPressed: _copyToClipboard,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (!isLoading && rootWords.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Түбір сөздер:',
                      style: TextStyle(
                        color: Color(0xFFF5C851),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    WordListWidget(words: rootWords),
                  ],
                ),
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
