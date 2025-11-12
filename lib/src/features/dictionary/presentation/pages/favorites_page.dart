import 'package:flutter/material.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/database/database_helper.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/widgets/word_list_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<WordModel> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => isLoading = true);
    final db = DatabaseHelper();
    final favs = await db.loadFavorites();
    setState(() {
      favorites = favs;
      isLoading = false;
    });
  }

  Future<void> _toggleFavorite(WordModel word) async {
    final updated = !word.isChosen;
    await DatabaseHelper().updateFavorite(word.id, updated);
    await _loadFavorites();
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
        child: RefreshIndicator(
          backgroundColor: const Color(0xFF1a2036),
          color: const Color(0xFFF5C851),
          onRefresh: _loadFavorites,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFF5C851),
                  ),
                )
              : favorites.isEmpty
                  ? const _EmptyState()
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: WordListWidget(
                        words: favorites,
                        onFavoriteToggle: _toggleFavorite,
                      ),
                    ),
        ),
      ),
    );
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
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
