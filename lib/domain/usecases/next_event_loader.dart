import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/repositories/load_next_event_repo.dart';

final class NextEventLoader {
  final LoadNextEventRepository repo;

  const NextEventLoader({
    required this.repo
  });

  Future<NextEvent> call({ required String groupId }) async {
    return repo.loadNextEvent(groupId: groupId);
  }
}
