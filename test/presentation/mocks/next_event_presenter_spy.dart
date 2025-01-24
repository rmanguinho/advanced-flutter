import 'package:advanced_flutter/presentation/presenters/next_event_presenter.dart';
import 'package:advanced_flutter/presentation/viewmodels/next_event_player_viewmodel.dart';
import 'package:advanced_flutter/presentation/viewmodels/next_event_viewmodel.dart';

import 'package:rxdart/rxdart.dart';

final class NextEventPresenterSpy implements NextEventPresenter {
  int callsCount = 0;
  String? groupId;
  bool? isReload;
  var nextEventSubject = BehaviorSubject<NextEventViewModel>();
  var isBusySubject = BehaviorSubject<bool>();

  @override
  Stream<NextEventViewModel> get nextEventStream => nextEventSubject.stream;

  @override
  Stream<bool> get isBusyStream => isBusySubject.stream;

  void emitNextEvent([NextEventViewModel? viewModel]) {
    nextEventSubject.add(viewModel ?? const NextEventViewModel());
  }

  void emitNextEventWith({ List<NextEventPlayerViewModel> goalkeepers = const [], List<NextEventPlayerViewModel> players = const [], List<NextEventPlayerViewModel> out = const [], List<NextEventPlayerViewModel> doubt = const [] }) {
    nextEventSubject.add(NextEventViewModel(goalkeepers: goalkeepers, players: players, out: out, doubt: doubt));
  }

  void emitError() {
    nextEventSubject.addError(Error());
  }

  void emitIsBusy([bool isBusy = true]) {
    isBusySubject.add(isBusy);
  }

  @override
  Future<void> loadNextEvent({ required String groupId, bool isReload = false }) async {
    callsCount++;
    this.groupId = groupId;
    this.isReload = isReload;
  }
}
