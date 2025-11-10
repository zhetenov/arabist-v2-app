import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordListWidget extends StatefulWidget {
  final List<Map<String, String>> words;
  final void Function(Map<String, String> word)? onFavoriteToggle;

  const WordListWidget({
    super.key,
    required this.words,
    this.onFavoriteToggle,
  });

  @override
  State<WordListWidget> createState() => _WordListWidgetState();
}

class _WordListWidgetState extends State<WordListWidget> {
  final FlutterTts _tts = FlutterTts();
  String? _speakingWord;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage("ar-SA");
    await _tts.setSpeechRate(0.6);
    await _tts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    setState(() => _speakingWord = text);
    await _tts.stop();
    await _tts.speak(text);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _speakingWord = null);
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty) {
      return const Center(
        child: Text(
          'No words found',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.words.length,
      itemBuilder: (context, index) {
        final word = widget.words[index];
        final isSpeaking = _speakingWord == word['arabic'];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1a2036),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // 🔊 Pronounce button
              GestureDetector(
                onTap: () => _speak(word['arabic']!),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: isSpeaking
                        ? const Color(0xFF2D9C8B)
                        : const Color(0xFF1E4258),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/sound.svg',
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF4DE6D1),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 🟡 Arabic + English
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word['arabic']!,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Color(0xFFF5C851),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word['english']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // ⭐ Favorite
              IconButton(
                onPressed: () => widget.onFavoriteToggle?.call(word),
                icon: const Icon(
                  Icons.star_border,
                  color: Color(0xFF3de0d0),
                  size: 24,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
