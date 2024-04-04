import 'package:advanced_flutter/domain/entities/next_event_player.dart';

import 'package:flutter_test/flutter_test.dart';

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

  test('should return "-" when name is empty', () {
    expect(initialsOf(''), '-');
  });

  test('should convert to uppercase', () {
    expect(initialsOf('rodrigo manguinho'), 'RM');
    expect(initialsOf('rodrigo'), 'RO');
    expect(initialsOf('r'), 'R');
  });

  test('should ignore extra whitespaces', () {
    expect(initialsOf('Rodrigo Manguinho '), 'RM');
    expect(initialsOf(' Rodrigo Manguinho'), 'RM');
    expect(initialsOf('Rodrigo  Manguinho'), 'RM');
    expect(initialsOf(' Rodrigo  Manguinho '), 'RM');
    expect(initialsOf(' Rodrigo '), 'RO');
    expect(initialsOf(' R '), 'R');
    expect(initialsOf(' '), '-');
    expect(initialsOf('  '), '-');
  });
}
