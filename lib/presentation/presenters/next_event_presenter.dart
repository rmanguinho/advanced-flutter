abstract class NextEventPresenter {
  Stream<NextEventViewModel> get nextEventStream;
  void loadNextEvent({ required String groupId });
}

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
}

final class NextEventPlayerViewModel {
  final String name;
  final String initials;
  final String? photo;
  final String? position;
  final bool? isConfirmed;

  const NextEventPlayerViewModel({
    required this.name,
    required this.initials,
    this.photo,
    this.position,
    this.isConfirmed
  });
}
