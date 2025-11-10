import 'package:arabist_v2_app/src/features/dictionary/presentation/widgets/word_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
   final controller = TextEditingController();
  List<Map<String, String>> words = [];

  
void _onSearch(String query) {
    // 🔍 временно мок-данные
    final allWords = [
      {'arabic': 'السلام', 'english': 'Peace'},
      {'arabic': 'الحمد لله', 'english': 'All praise is due to Allah'},
      {'arabic': 'إيمان', 'english': 'Faith'},
      {'arabic': 'صبر', 'english': 'Patience'},
      {'arabic': 'شكر', 'english': 'Gratitude'},
    ];
    setState(() {
      words = allWords
          .where((w) =>
              w['arabic']!.contains(query) ||
              w['english']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F2B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a2036),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/search.svg',
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                         Color(0xFF7d7f88),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller,
                         onChanged: _onSearch,
                        style: const TextStyle(color: Color(0xFFdedede), fontSize: 16),
                        cursorColor: Colors.white54,
                        decoration: const InputDecoration(
                          hintText: 'Search for Arabic words...',
                          hintStyle: TextStyle(color:  Color(0xFF7d7f88)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.clear(),
                      icon: const Icon(Icons.close, color:  Color(0xFF7d7f88), size: 20),
                    ),
                  ],
                ),
              ),
             const SizedBox(height: 16),

              // 📜 Word list
              Expanded(
                child: WordListWidget(words: words),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
