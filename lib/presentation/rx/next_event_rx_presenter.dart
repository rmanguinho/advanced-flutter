import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/presentation/presenters/next_event_presenter.dart';

import 'package:dartx/dartx.dart';
import 'package:rxdart/rxdart.dart';

final class NextEventRxPresenter implements NextEventPresenter {
  final Future<NextEvent> Function({ required String groupId }) nextEventLoader;
  final nextEventSubject = BehaviorSubject<NextEventViewModel>();
  final isBusySubject = BehaviorSubject<bool>();

  NextEventRxPresenter({
    required this.nextEventLoader
  });

  @override
  Stream<NextEventViewModel> get nextEventStream => nextEventSubject.stream;

  @override
  Stream<bool> get isBusyStream => isBusySubject.stream;

  @override
  Future<void> loadNextEvent({ required String groupId, bool isReload = false }) async {
    try {
      if (isReload) isBusySubject.add(true);
      final event = await nextEventLoader(groupId: groupId);
      nextEventSubject.add(_mapEvent(event));
    } catch (error) {
      nextEventSubject.addError(error);
    } finally {
      if (isReload) isBusySubject.add(false);
    }
  }

  Iterable<NextEventPlayer> _doubt(List<NextEventPlayer> players) => players.where((player) => player.confirmationDate == null);
  Iterable<NextEventPlayer> _confirmed(List<NextEventPlayer> players) => players.where((player) => player.confirmationDate != null);
  Iterable<NextEventPlayer> _in(List<NextEventPlayer> players) => _confirmed(players).where((player) => player.isConfirmed);
  Iterable<NextEventPlayer> _out(List<NextEventPlayer> players) => _confirmed(players).where((player) => !player.isConfirmed);
  Iterable<NextEventPlayer> _goalkeepers(List<NextEventPlayer> players) => _in(players).where((player) => player.position == 'goalkeeper');
  Iterable<NextEventPlayer> _players(List<NextEventPlayer> players) => _in(players).where((player) => player.position != 'goalkeeper');
  Comparable _sortByDate(NextEventPlayer player) => player.confirmationDate!;
  Comparable _sortByName(NextEventPlayer player) => player.name;

  NextEventViewModel _mapEvent(NextEvent event) => NextEventViewModel(
    doubt: _mapPlayers(_doubt(event.players).sortedBy(_sortByName)),
    out: _mapPlayers(_out(event.players).sortedBy(_sortByDate)),
    goalkeepers: _mapPlayers(_goalkeepers(event.players).sortedBy(_sortByDate)),
    players: _mapPlayers(_players(event.players).sortedBy(_sortByDate))
  );

  NextEventPlayerViewModel _mapPlayer(NextEventPlayer player) => NextEventPlayerViewModel(
    name: player.name,
    initials: player.initials,
    photo: player.photo,
    position: player.position,
    isConfirmed: player.confirmationDate == null ? null : player.isConfirmed
  );

  List<NextEventPlayerViewModel> _mapPlayers(List<NextEventPlayer> players) => players.map(_mapPlayer).toList();
}
