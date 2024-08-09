import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/infra/mappers/next_event_mapper.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakes.dart';
import '../mocks/list_mapper_spy.dart';

void main() {
  late ListMapperSpy<NextEventPlayer> playerMapper;
  late NextEventMapper sut;

  setUp(() {
    playerMapper = ListMapperSpy(toDtoListOutput: anyNextEventPlayerList());
    sut = NextEventMapper(playerMapper: playerMapper);
  });

  test('should map to dto', () {
    final json = {
      'groupName': anyString(),
      'date': '2024-08-29T11:00:00.000',
      'players': anyJsonArr()
    };
    final dto = sut.toDto(json);
    expect(dto.groupName, json['groupName']);
    expect(dto.date, DateTime(2024, 8, 29, 11, 0));
    expect(playerMapper.toDtoListIntput, json['players']);
    expect(playerMapper.toDtoListCallsCount, 1);
    expect(dto.players, playerMapper.toDtoListOutput);
  });

  test('should map to json', () {
    final dto = NextEvent(
      groupName: anyString(),
      date: DateTime(2024, 8, 29, 13, 0),
      players: anyNextEventPlayerList()
    );
    final json = sut.toJson(dto);
    expect(json['groupName'], dto.groupName);
    expect(json['date'], '2024-08-29T13:00:00.000');
    expect(playerMapper.toJsonArrIntput, dto.players);
    expect(playerMapper.toJsonArrCallsCount, 1);
    expect(json['players'], playerMapper.toJsonArrOutput);
  });
}
