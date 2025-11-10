import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:flutter/material.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final repo = DictionaryRepositoryImpl();
  final controller = TextEditingController();
  List<WordModel> words = [];

  Future<void> _search(String query) async {
    final results = await repo.searchWords(query);
    setState(() => words = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arabist v2')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search Arabic / Kazakh / Russian',
              ),
              onChanged: _search,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: words.isEmpty
                  ? const Center(child: Text('No results'))
                  : ListView.builder(
                      itemCount: words.length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(words[i].arabic),
                        subtitle: Text(words[i].kazakh ?? ''),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
