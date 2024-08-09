import 'package:advanced_flutter/infra/mappers/next_event_player_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakes.dart';

void main() {
  late NextEventPlayerMapper sut;

  setUp(() {
    sut = NextEventPlayerMapper();
  });

  test('should map to dto', () {
    final json = {
      'id': anyString(),
      'name': anyString(),
      'position': anyString(),
      'photo': anyString(),
      'confirmationDate': '2024-08-29T11:00:00.000',
      'isConfirmed': anyBool()
    };
    final dto = sut.toDto(json);
    expect(dto.id, json['id']);
    expect(dto.name, json['name']);
    expect(dto.position, json['position']);
    expect(dto.photo, json['photo']);
    expect(dto.confirmationDate, DateTime(2024, 8, 29, 11, 0));
    expect(dto.isConfirmed, json['isConfirmed']);
  });

  test('should map to dto with empty fields', () {
    final json = {
      'id': anyString(),
      'name': anyString(),
      'isConfirmed': anyBool()
    };
    final dto = sut.toDto(json);
    expect(dto.id, json['id']);
    expect(dto.name, json['name']);
    expect(dto.position, isNull);
    expect(dto.photo, isNull);
    expect(dto.confirmationDate, isNull);
    expect(dto.isConfirmed, json['isConfirmed']);
  });
}
