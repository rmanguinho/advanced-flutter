import 'package:advanced_flutter/presentation/viewmodels/next_event_viewmodel.dart';

abstract class NextEventPresenter {
  Stream<NextEventViewModel> get nextEventStream;
  Stream<bool> get isBusyStream;

  Future<void> loadNextEvent({ required String groupId, bool isReload });
}
