import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arabist_v2_app/src/features/dictionary/cubit/search_cubit.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/database/database_helper.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/widgets/word_list_widget.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final TextEditingController controller = TextEditingController();
  TextDirection textDirection = TextDirection.ltr;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SearchCubit(DictionaryRepositoryImpl(DatabaseHelper())),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0F2B),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _SearchBar(
                  controller: controller,
                  textDirection: textDirection,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state is SearchInitial) {
                        return const Center(
                          child: Text(
                            'Start typing...',
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      } else if (state is SearchLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is SearchEmpty) {
                        return const Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      } else if (state is SearchLoaded) {
                        return SingleChildScrollView(
                          child: WordListWidget(
                            words: state.words,
                            onFavoriteToggle: (word) => context
                                .read<SearchCubit>()
                                .toggleFavorite(word),
                          ),
                        );
                      } else if (state is SearchError) {
                        return Center(
                          child: Text(
                            'Error: ${state.message}',
                            style:
                                const TextStyle(color: Colors.redAccent),
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
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final TextDirection textDirection;

  const _SearchBar({
    required this.controller,
    required this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
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
              onChanged: (value) =>
                  context.read<SearchCubit>().search(value),
              style: const TextStyle(
                color: Color(0xFFdedede),
                fontSize: 16,
              ),
              cursorColor: Colors.white54,
              decoration: const InputDecoration(
                hintText: 'Search Arabic or Kazakh...',
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
            icon: const Icon(
              Icons.close,
              color: Color(0xFF7d7f88),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
