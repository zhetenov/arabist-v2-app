import 'package:arabist_v2_app/src/features/dictionary/cubit/favorite_cubit.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/database/database_helper.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/pages/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/widgets/word_list_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesCubit>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F2B),
      floatingActionButton: BlocBuilder<FavoritesCubit, List<WordModel>>(
        builder: (context, favorites) {
          return favorites.isNotEmpty
              ? FloatingActionButton.extended(
                  backgroundColor: const Color(0xFFF5C851),
                  icon: SvgPicture.asset(
                    'assets/images/lightning.svg',
                    height: 22,
                    width: 22,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: const Text(
                    'Жаттығу',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizPage()),
                    );
                  },
                )
              : const SizedBox.shrink();
        },
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F2B),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Таңдаулылар',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<FavoritesCubit, List<WordModel>>(
          builder: (context, favorites) {
            return RefreshIndicator(
              backgroundColor: const Color(0xFF1a2036),
              color: const Color(0xFFF5C851),
              onRefresh: () => context.read<FavoritesCubit>().refresh(),
              child: favorites.isEmpty
                  ? const _EmptyState()
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: WordListWidget(
                        words: favorites,
                        onFavoriteToggle: _toggleFavorite,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(WordModel word) async {
    final db = DatabaseHelper();
    final updated = !word.isChosen;
    
    await db.updateFavorite(word.id, updated);
    
    context.read<FavoritesCubit>().refresh();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, color: Color(0xFFF5C851), size: 70),
            SizedBox(height: 16),
            Text(
              'Таңдаулылар бос',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Жұлдызшаны басып, сөздерді таңдаулыға қосыңыз.',
              style: TextStyle(color: Colors.white70, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}