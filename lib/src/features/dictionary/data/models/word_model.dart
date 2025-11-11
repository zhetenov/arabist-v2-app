import 'package:equatable/equatable.dart';

class WordModel extends Equatable {
  final int id;
  final String? kazakh;
  final String? search;
  final String? arabic;
  final String? arabicSecond;
  final String? pluralLetters;
  final String? longWords;
  final String? shortWords;
  final String? description;
  final int? rootId;
  final bool isChosen;
  final bool isInGame;
  final DateTime? viewedAt;

  const WordModel({
    required this.id,
    this.kazakh,
    this.search,
    this.arabic,
    this.arabicSecond,
    this.pluralLetters,
    this.longWords,
    this.shortWords,
    this.description,
    this.rootId,
    this.isChosen = false,
    this.isInGame = false,
    this.viewedAt,
  });

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id'].toString()) ?? 0,
      kazakh: map['kazakh']?.toString(),
      search: map['search']?.toString(),
      arabic: map['arabic']?.toString(),
      arabicSecond: map['arabic_sec']?.toString(),
      pluralLetters: map['plural_letters']?.toString(),
      longWords: map['long_words']?.toString(),
      shortWords: map['short_words']?.toString(),
      description: map['description']?.toString(),
      rootId: map['root_id'] == null
          ? null
          : int.tryParse(map['root_id'].toString()),
      isChosen: (map['is_chosen'] ?? 0) == 1,
      isInGame: (map['is_in_game'] ?? 0) == 1,
      viewedAt: map['viewed_at'] != null
          ? DateTime.tryParse(map['viewed_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kazakh': kazakh,
      'search': search,
      'arabic': arabic,
      'arabic_sec': arabicSecond,
      'plural_letters': pluralLetters,
      'long_words': longWords,
      'short_words': shortWords,
      'description': description,
      'root_id': rootId,
      'is_chosen': isChosen ? 1 : 0,
      'is_in_game': isInGame ? 1 : 0,
      'viewed_at': viewedAt?.toIso8601String(),
    };
  }

  WordModel copyWith({
    int? id,
    String? kazakh,
    String? search,
    String? arabic,
    String? arabicSecond,
    String? pluralLetters,
    String? longWords,
    String? shortWords,
    String? description,
    int? rootId,
    bool? isChosen,
    bool? isInGame,
    DateTime? viewedAt,
  }) {
    return WordModel(
      id: id ?? this.id,
      kazakh: kazakh ?? this.kazakh,
      search: search ?? this.search,
      arabic: arabic ?? this.arabic,
      arabicSecond: arabicSecond ?? this.arabicSecond,
      pluralLetters: pluralLetters ?? this.pluralLetters,
      longWords: longWords ?? this.longWords,
      shortWords: shortWords ?? this.shortWords,
      description: description ?? this.description,
      rootId: rootId ?? this.rootId,
      isChosen: isChosen ?? this.isChosen,
      isInGame: isInGame ?? this.isInGame,
      viewedAt: viewedAt ?? this.viewedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        kazakh,
        search,
        arabic,
        arabicSecond,
        pluralLetters,
        longWords,
        shortWords,
        description,
        rootId,
        isChosen,
        isInGame,
        viewedAt,
      ];
}
