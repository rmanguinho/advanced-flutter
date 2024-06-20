import 'package:advanced_flutter/presentation/presenters/next_event_presenter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

import '../../helpers/fakes.dart';

final class NextEventPage extends StatefulWidget {
  final NextEventPresenter presenter;
  final String groupId;

  const NextEventPage({
    required this.presenter,
    required this.groupId,
    super.key
  });

  @override
  State<NextEventPage> createState() => _NextEventPageState();
}

class _NextEventPageState extends State<NextEventPage> {
  @override
  void initState() {
    widget.presenter.loadNextEvent(groupId: widget.groupId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<NextEventViewModel>(
        stream: widget.presenter.nextEventStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) return const CircularProgressIndicator();
          if (snapshot.hasError) return const SizedBox();
          final viewModel = snapshot.data!;
          return ListView(
            children: [
              if (viewModel.goalkeepers.isNotEmpty) ListSection(title: 'DENTRO - GOLEIROS', items: viewModel.goalkeepers),
              if (viewModel.players.isNotEmpty) ListSection(title: 'DENTRO - JOGADORES', items: viewModel.players),
              if (viewModel.out.isNotEmpty) ListSection(title: 'FORA', items: viewModel.out),
              if (viewModel.doubt.isNotEmpty) ListSection(title: 'DÚVIDA', items: viewModel.doubt)
            ]
          );
        }
      )
    );
  }
}

final class ListSection extends StatelessWidget {
  final String title;
  final List<NextEventPlayerViewModel> items;

  const ListSection({
    required this.title,
    required this.items,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Text(items.length.toString()),
        ...items.map((player) => Text(player.name))
      ]
    );
  }
}


final class NextEventPresenterSpy implements NextEventPresenter {
  int loadCallsCount = 0;
  String? groupId;
  var nextEventSubject = BehaviorSubject<NextEventViewModel>();

  @override
  Stream<NextEventViewModel> get nextEventStream => nextEventSubject.stream;

  void emitNextEvent([NextEventViewModel? viewModel]) {
    nextEventSubject.add(viewModel ?? const NextEventViewModel());
  }

  void emitNextEventWith({ List<NextEventPlayerViewModel> goalkeepers = const [], List<NextEventPlayerViewModel> players = const [], List<NextEventPlayerViewModel> out = const [], List<NextEventPlayerViewModel> doubt = const [] }) {
    nextEventSubject.add(NextEventViewModel(goalkeepers: goalkeepers, players: players, out: out, doubt: doubt));
  }

  void emitError() {
    nextEventSubject.addError(Error());
  }

  @override
  void loadNextEvent({ required String groupId }) {
    loadCallsCount++;
    this.groupId = groupId;
  }
}

void main() {
  late NextEventPresenterSpy presenter;
  late String groupId;
  late Widget sut;

  setUp(() {
    presenter = NextEventPresenterSpy();
    groupId = anyString();
    sut = MaterialApp(home: NextEventPage(presenter: presenter, groupId: groupId));
  });

  testWidgets('should load event data on page init', (tester) async {
    await tester.pumpWidget(sut);
    expect(presenter.loadCallsCount, 1);
    expect(presenter.groupId, groupId);
  });

  testWidgets('should present spinner while data is loading', (tester) async {
    await tester.pumpWidget(sut);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should hide spinner on load success', (tester) async {
    await tester.pumpWidget(sut);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    presenter.emitNextEvent();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should hide spinner on load error', (tester) async {
    await tester.pumpWidget(sut);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    presenter.emitError();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should present goalkeepers section', (tester) async {
    await tester.pumpWidget(sut);
    presenter.emitNextEventWith(goalkeepers: const [
      NextEventPlayerViewModel(name: 'Rodrigo'),
      NextEventPlayerViewModel(name: 'Rafael'),
      NextEventPlayerViewModel(name: 'Pedro')
    ]);
    await tester.pump();
    expect(find.text('DENTRO - GOLEIROS'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Rodrigo'), findsOneWidget);
    expect(find.text('Rafael'), findsOneWidget);
    expect(find.text('Pedro'), findsOneWidget);
  });

  testWidgets('should present players section', (tester) async {
    await tester.pumpWidget(sut);
    presenter.emitNextEventWith(players: const [
      NextEventPlayerViewModel(name: 'Rodrigo'),
      NextEventPlayerViewModel(name: 'Rafael'),
      NextEventPlayerViewModel(name: 'Pedro')
    ]);
    await tester.pump();
    expect(find.text('DENTRO - JOGADORES'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Rodrigo'), findsOneWidget);
    expect(find.text('Rafael'), findsOneWidget);
    expect(find.text('Pedro'), findsOneWidget);
  });

  testWidgets('should present out section', (tester) async {
    await tester.pumpWidget(sut);
    presenter.emitNextEventWith(out: const [
      NextEventPlayerViewModel(name: 'Rodrigo'),
      NextEventPlayerViewModel(name: 'Rafael'),
      NextEventPlayerViewModel(name: 'Pedro')
    ]);
    await tester.pump();
    expect(find.text('FORA'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Rodrigo'), findsOneWidget);
    expect(find.text('Rafael'), findsOneWidget);
    expect(find.text('Pedro'), findsOneWidget);
  });

  testWidgets('should present doubt section', (tester) async {
    await tester.pumpWidget(sut);
    presenter.emitNextEventWith(doubt: const [
      NextEventPlayerViewModel(name: 'Rodrigo'),
      NextEventPlayerViewModel(name: 'Rafael'),
      NextEventPlayerViewModel(name: 'Pedro')
    ]);
    await tester.pump();
    expect(find.text('DÚVIDA'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Rodrigo'), findsOneWidget);
    expect(find.text('Rafael'), findsOneWidget);
    expect(find.text('Pedro'), findsOneWidget);
  });

  testWidgets('should hide all sections', (tester) async {
    await tester.pumpWidget(sut);
    presenter.emitNextEvent();
    await tester.pump();
    expect(find.text('DENTRO - GOLEIROS'), findsNothing);
    expect(find.text('DENTRO - JOGADORES'), findsNothing);
    expect(find.text('FORA'), findsNothing);
    expect(find.text('DÚVIDA'), findsNothing);
  });
}
