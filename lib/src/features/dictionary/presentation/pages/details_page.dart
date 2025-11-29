import 'package:arabist_v2_app/src/features/dictionary/data/database/arabic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arabist_v2_app/src/features/dictionary/cubit/favorite_cubit.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/database/database_helper.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/widgets/word_list_widget.dart';

class DetailsPage extends StatefulWidget {
  final WordModel word;
  final void Function(WordModel word)? onFavoriteToggle;

  const DetailsPage({super.key, required this.word, this.onFavoriteToggle});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<WordModel> rootWords = [];
  bool isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.word.isChosen;
    DatabaseHelper().updateViewedAt(widget.word.id);
    _loadRoots();
  }

  Future<void> _loadRoots() async {
    setState(() => isLoading = true);
    final db = DatabaseHelper();
    final roots = await db.loadRoots(widget.word.rootId ?? 0, widget.word.id);
    setState(() {
      rootWords = roots;
      isLoading = false;
    });
  }

  Future<void> _toggleRootFavorite(WordModel rootWord) async {
    final db = DatabaseHelper();
    final updated = !rootWord.isChosen;

    await db.updateFavorite(rootWord.id, updated);

    setState(() {
      rootWords = rootWords
          .map((w) => w.id == rootWord.id ? w.copyWith(isChosen: updated) : w)
          .toList();
    });

    context.read<FavoritesCubit>().refresh();
  }

  Future<void> _copyToClipboard() async {
    final text =
        '${widget.word.arabic ?? ''}\n${widget.word.kazakh ?? ''}\n${widget.word.description ?? ''}';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.word.arabic?.isNotEmpty == true
        ? widget.word.arabic!
        : (widget.word.kazakh ?? 'Толық ақпарат');

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
          textDirection: isArabic(title)
              ? TextDirection.rtl
              : TextDirection.ltr,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            widget.word.arabic ?? '',
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
                              widget.word.arabicSecond ?? '',
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
                      widget.word.description ?? widget.word.kazakh ?? '',
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
                          icon: Icon(
                            _isFavorite ? Icons.star : Icons.star_border,
                            color: const Color(0xFFF5C851),
                            size: 28,
                          ),
                          onPressed: () async {
                            await _toggleRootFavorite(widget.word);
                            if (mounted) {
                              setState(() {
                                _isFavorite = !_isFavorite;
                              });
                            }
                          },
                        ),
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
                    WordListWidget(
                      words: rootWords,
                      onAfterDetailsPop: _loadRoots,
                      onFavoriteToggle: _toggleRootFavorite,
                    ),
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
