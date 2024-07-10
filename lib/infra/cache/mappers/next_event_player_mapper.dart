import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/infra/cache/mappers/mapper.dart';

final class NextEventPlayerMapper extends Mapper<NextEventPlayer> {
  @override
  NextEventPlayer toObject(dynamic json) => NextEventPlayer(
    id: json['id'],
    name: json['name'],
    position: json['position'],
    photo: json['photo'],
    confirmationDate: json['confirmationDate'],
    isConfirmed: json['isConfirmed']
  );
}
