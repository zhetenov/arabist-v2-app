import 'package:flutter/material.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/pages/details_page.dart';

class WordListWidget extends StatelessWidget {
  final List<WordModel> words;
  final void Function(WordModel word)? onFavoriteToggle;
  final VoidCallback? onAfterDetailsPop;

  const WordListWidget({
    super.key,
    required this.words,
    this.onFavoriteToggle,
    this.onAfterDetailsPop,
  });

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Center(
        child: Text('No words found', style: TextStyle(color: Colors.white54)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 4),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];
        return _WordCard(
          word: word,
          onFavoriteToggle: onFavoriteToggle,
          onAfterDetailsPop: onAfterDetailsPop,
        );
      },
    );
  }
}

class _WordCard extends StatelessWidget {
  final WordModel word;
  final void Function(WordModel word)? onFavoriteToggle;
  final VoidCallback? onAfterDetailsPop;

  const _WordCard({
    required this.word,
    this.onFavoriteToggle,
    this.onAfterDetailsPop,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsPage(
              word: word,
              onFavoriteToggle: onFavoriteToggle,
            ),
          ),
        );
        onAfterDetailsPop?.call();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1a2036),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildArabicRow(),
                  const SizedBox(height: 6),
                  Text(
                    word.kazakh ?? word.description ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                word.isChosen ? Icons.star : Icons.star_border,
                color: const Color(0xFF3de0d0),
                size: 22,
              ),
              onPressed: () => onFavoriteToggle?.call(word),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArabicRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 5,
          child: Text(
            word.arabic ?? '',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Color(0xFFF5C851),
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 5,
          child: Text(
            word.arabicSecond ?? '',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Color(0xFFb7b7b7),
              fontSize: 20,
              fontWeight: FontWeight.w400,
              height: 1.1,
            ),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
