import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final int id;
  final String arabic;
  final String? kazakh;
  final String? russian;
  final String? description;

  const Word({
    required this.id,
    required this.arabic,
    this.kazakh,
    this.russian,
    this.description,
  });

  @override
  List<Object?> get props => [id, arabic, kazakh, russian, description];
}
