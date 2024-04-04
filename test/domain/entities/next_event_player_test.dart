import 'package:flutter_test/flutter_test.dart';

class NextEventPlayer {
  final String id;
  final String name;
  final String? photo;
  final String? position;
  final bool isConfirmed;
  final DateTime? confirmationDate;

  NextEventPlayer({
    required this.id,
    required this.name,
    required this.isConfirmed,
    this.photo,
    this.position,
    this.confirmationDate
  });

  String getInitials() {
    final names = name.split(' ');
    return '${names[0][0]}${names[1][0]}';
  }
}

void main() {
  test('should return the first letter of the first and last names', () {
    final player = NextEventPlayer(
      id: '',
      name: 'Rodrigo Manguinho',
      isConfirmed: true
    );
    expect(player.getInitials(), 'RM');
    final player2 = NextEventPlayer(
      id: '',
      name: 'Pedro Carvalho',
      isConfirmed: true
    );
    expect(player2.getInitials(), 'PC');
  });
}
