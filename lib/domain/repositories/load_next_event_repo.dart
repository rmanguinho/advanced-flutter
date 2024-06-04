import 'package:advanced_flutter/domain/entities/next_event.dart';

abstract interface class LoadNextEventRepository {
  Future<NextEvent> loadNextEvent({ required String groupId });
}
