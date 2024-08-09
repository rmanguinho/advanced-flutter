import 'package:advanced_flutter/infra/mappers/next_event_mapper.dart';
import 'package:advanced_flutter/main/factories/infra/mappers/next_event_player_mapper_factory.dart';

NextEventMapper makeNextEventMapper() => NextEventMapper(playerMapper: makeNextEventPLayerMapper());
