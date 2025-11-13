import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:arabist_v2_app/src/features/dictionary/cubit/search_cubit.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/database/database_helper.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/widgets/word_list_widget.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final TextEditingController controller = TextEditingController();
  TextDirection textDirection = TextDirection.ltr;
  List<WordModel> history = [];
  bool isLoadingHistory = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
    _loadHistory();
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = controller.text.trim();
    setState(() {
      textDirection = _isArabic(text) ? TextDirection.rtl : TextDirection.ltr;
    });
  }

  bool _isArabic(String text) {
    if (text.isEmpty) return false;
    final code = text.codeUnitAt(0);
    return code >= 0x0600 && code <= 0x06FF;
  }

  Future<void> _loadHistory() async {
    setState(() => isLoadingHistory = true);
    final db = DatabaseHelper();
    final list = await db.loadHistory();
    setState(() {
      history = list.cast<WordModel>();
      isLoadingHistory = false;
    });
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a2036),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Ақпарат',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/nmu.png',
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Nur-Mubarak UNIVERSITY',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Бұл қосымша араб және қазақ тіліндегі сөздерді '
                'іздеу, үйрену және есте сақтау үшін жасалған.\n\n'
                'Мүмкіндіктер:\n'
                '• Іздеу арқылы сөз табу\n'
                '• Таңдаулы сөздер тізімін жасау\n'
                '• Тест арқылы білімді тексеру\n\n'
                'Версия: 1.0.0\n',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Жабу',
              style: TextStyle(color: Color(0xFFF5C851)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F2B),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Іздеу',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
        leadingWidth: 90,
        leading: GestureDetector(
          onTap: () async {
            final url = Uri.parse('https://www.almaany.com/');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
          child: const Center(
            child: Text(
              'المعاني',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _SearchBar(controller: controller, textDirection: textDirection),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (controller.text.isEmpty) {
                      if (isLoadingHistory) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF5C851),
                          ),
                        );
                      }
                      if (history.isEmpty) {
                        return const Center(
                          child: Text(
                            'Соңғы қаралған сөздер жоқ',
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      }
                      return RefreshIndicator(
                        backgroundColor: const Color(0xFF1a2036),
                        color: const Color(0xFFF5C851),
                        onRefresh: _loadHistory,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Text(
                                  'Соңғы қаралған сөздер:',
                                  style: TextStyle(
                                    color: Color(0xFFF5C851),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              WordListWidget(
                                words: history,
                                onAfterDetailsPop: _loadHistory,
                                onFavoriteToggle: (word) async {
                                  final db = DatabaseHelper();
                                  await db.updateFavorite(
                                    word.id,
                                    !word.isChosen,
                                  );
                                  _loadHistory();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // 👇 иначе показываем результаты поиска
                    if (state is SearchInitial) {
                      return const Center(
                        child: Text(
                          'Іздеуді бастаңыз...',
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    } else if (state is SearchLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF5C851),
                        ),
                      );
                    } else if (state is SearchEmpty) {
                      return const Center(
                        child: Text(
                          'Ештеңе табылмады',
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    } else if (state is SearchLoaded) {
                      return SingleChildScrollView(
                        child: WordListWidget(
                          words: state.words,
                          onFavoriteToggle: (word) =>
                              context.read<SearchCubit>().toggleFavorite(word),
                          onAfterDetailsPop: _loadHistory,
                        ),
                      );
                    } else if (state is SearchError) {
                      return Center(
                        child: Text(
                          'Қате: ${state.message}',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final TextDirection textDirection;

  const _SearchBar({required this.controller, required this.textDirection});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2036),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF7d7f88)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              textDirection: textDirection,
              onChanged: (value) => context.read<SearchCubit>().search(value),
              style: const TextStyle(color: Color(0xFFdedede), fontSize: 16),
              cursorColor: Colors.white54,
              decoration: const InputDecoration(
                hintText: 'Сөзді енгізіңіз',
                hintStyle: TextStyle(color: Color(0xFF7d7f88)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              controller.clear();
              context.read<SearchCubit>().search('');
            },
            icon: const Icon(Icons.close, color: Color(0xFF7d7f88), size: 20),
          ),
        ],
      ),
    );
  }
}
