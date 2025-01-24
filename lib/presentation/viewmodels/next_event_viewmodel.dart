import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/presentation/viewmodels/next_event_player_viewmodel.dart';

final class NextEventViewModel {
  final List<NextEventPlayerViewModel> goalkeepers;
  final List<NextEventPlayerViewModel> players;
  final List<NextEventPlayerViewModel> out;
  final List<NextEventPlayerViewModel> doubt;

  const NextEventViewModel({
    this.goalkeepers = const [],
    this.players = const [],
    this.out = const [],
    this.doubt = const []
  });

  factory NextEventViewModel.fromEntity(NextEvent event) => NextEventViewModel(
    doubt: NextEventPlayerViewModel.mapDoubtPlayers(event.players),
    out: NextEventPlayerViewModel.mapOutPlayers(event.players),
    goalkeepers: NextEventPlayerViewModel.mapGoalkeepers(event.players),
    players: NextEventPlayerViewModel.mapInPlayers(event.players)
  );
}
