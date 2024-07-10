import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/cache/mappers/mapper.dart';
import 'package:advanced_flutter/infra/cache/mappers/next_event_player_mapper.dart';

final class NextEventMapper extends Mapper<NextEvent> {
  @override
  NextEvent toObject(dynamic json) => NextEvent(
    groupName: json['groupName'],
    date: json['date'],
    players: NextEventPlayerMapper().toList(json['players'])
  );
}
