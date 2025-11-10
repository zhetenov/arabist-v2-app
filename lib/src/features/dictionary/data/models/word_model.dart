
import 'package:arabist_v2_app/src/features/dictionary/domain/entities/word.dart';

class WordModel extends Word {
  const WordModel({
    required super.id,
    required super.arabic,
    super.kazakh,
    super.russian,
    super.description,
  });

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'] as int,
      arabic: map['arabic'] ?? '',
      kazakh: map['kazakh'],
      russian: map['russian'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'arabic': arabic,
        'kazakh': kazakh,
        'russian': russian,
        'description': description,
      };
}
