import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/api/mappers/next_event_player_mapper.dart';
import 'package:advanced_flutter/infra/types/json.dart';

class NextEventMapper {
  static NextEvent toObject(Json json) => NextEvent(
    groupName: json['groupName'],
    date: DateTime.parse(json['date']),
    players: NextEventPlayerMapper.toList(json['players'])
  );
}
