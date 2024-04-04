import 'package:flutter_test/flutter_test.dart';

class NextEventPlayer {
  final String id;
  final String name;
  final String initials;
  final String? photo;
  final String? position;
  final bool isConfirmed;
  final DateTime? confirmationDate;

  NextEventPlayer._({
    required this.id,
    required this.name,
    required this.initials,
    required this.isConfirmed,
    this.photo,
    this.position,
    this.confirmationDate
  });

  factory NextEventPlayer({
    required String id,
    required String name,
    required bool isConfirmed,
    String? photo,
    String? position,
    DateTime? confirmationDate
  }) => NextEventPlayer._(
    id: id,
    name: name,
    photo: photo,
    position: position,
    initials: _getInitials(name),
    isConfirmed: isConfirmed,
    confirmationDate: confirmationDate
  );

  static String _getInitials(String name) {
    final names = name.toUpperCase().split(' ');
    final firstChar = names.first[0];
    final lastChar = names.last.split('').elementAtOrNull(names.length == 1 ? 1 : 0) ?? '';
    return '$firstChar$lastChar';
  }
}

void main() {
  String initialsOf(String name) => NextEventPlayer(id: '', name: name, isConfirmed: true).initials;

  test('should return the first letter of the first and last names', () {
    expect(initialsOf('Rodrigo Manguinho'), 'RM');
    expect(initialsOf('Pedro Carvalho'), 'PC');
    expect(initialsOf('Ingrid Mota da Silva'), 'IS');
  });

  test('should return the first letters of the first name', () {
    expect(initialsOf('Rodrigo'), 'RO');
    expect(initialsOf('R'), 'R');
  });

  test('should convert to uppercase', () {
    expect(initialsOf('rodrigo manguinho'), 'RM');
    expect(initialsOf('rodrigo'), 'RO');
    expect(initialsOf('r'), 'R');
  });
}
