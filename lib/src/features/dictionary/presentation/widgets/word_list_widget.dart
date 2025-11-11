import 'package:flutter/material.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/pages/details_page.dart';

class WordListWidget extends StatelessWidget {
  final List<WordModel> words;
  final void Function(WordModel word)? onFavoriteToggle;

  const WordListWidget({
    super.key,
    required this.words,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      child: words.isEmpty
          ? const _EmptyPlaceholder()
          : ListView.builder(
              key: const ValueKey('word_list'),
              padding: const EdgeInsets.only(top: 4),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                return _AnimatedWordCard(
                  key: ValueKey(word.id),
                  word: word,
                  delay: 40 * index,
                  onFavoriteToggle: onFavoriteToggle,
                );
              },
            ),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder();

  @override
  Widget build(BuildContext context) => const Center(
        key: ValueKey('empty'),
        child: Text(
          'No words found',
          style: TextStyle(color: Colors.white54),
        ),
      );
}

class _AnimatedWordCard extends StatelessWidget {
  final WordModel word;
  final int delay;
  final void Function(WordModel word)? onFavoriteToggle;

  const _AnimatedWordCard({
    super.key,
    required this.word,
    required this.delay,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 10),
          child: child,
        ),
      ),
      child: _WordCard(
        word: word,
        onFavoriteToggle: onFavoriteToggle,
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  final WordModel word;
  final void Function(WordModel word)? onFavoriteToggle;

  const _WordCard({
    required this.word,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailsPage(word: word),
            settings: RouteSettings(
              name: 'details',
              arguments: word,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1a2036),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
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
                  ),
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
            const SizedBox(width: 10),
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
}
