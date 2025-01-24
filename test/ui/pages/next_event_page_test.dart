import 'package:advanced_flutter/presentation/viewmodels/next_event_player_viewmodel.dart';
import 'package:advanced_flutter/ui/components/player_photo.dart';
import 'package:advanced_flutter/ui/components/player_position.dart';
import 'package:advanced_flutter/ui/components/player_status.dart';
import 'package:advanced_flutter/ui/pages/next_event_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakes.dart';
import '../../presentation/mocks/next_event_presenter_spy.dart';

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
    expect(presenter.callsCount, 1);
    expect(presenter.groupId, groupId);
    expect(presenter.isReload, false);
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
    presenter.emitNextEventWith(goalkeepers: [
      NextEventPlayerViewModel(name: 'Rodrigo', initials: anyString()),
      NextEventPlayerViewModel(name: 'Rafael', initials: anyString()),
      NextEventPlayerViewModel(name: 'Pedro', initials: anyString())
    ]);
    await tester.pump();
    expect(find.text('DENTRO - GOLEIROS'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Rodrigo'), findsOneWidget);
    expect(find.text('Rafael'), findsOneWidget);
    expect(find.text('Pedro'), findsOneWidget);
    expect(find.byType(PlayerPosition), findsExactly(3));
    expect(find.byType(PlayerStatus), findsExactly(3));
    expect(find.byType(PlayerPhoto), findsExactly(3));
  });

  testWidgets('should present players section', (tester) async {
    await tester.pumpWidget(sut);
    presenter.emitNextEventWith(players: [
      NextEventPlayerViewModel(name: 'Rodrigo', initials: anyString()),
      NextEventPlayerViewModel(name: 'Rafael', initials: anyString()),
      NextEventPlayerViewModel(name: 'Pedro', initials: anyString())
    ]);
    await tester.pump();
    expect(find.text('DENTRO - JOGADORES'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Rodrigo'), findsOneWidget);
    expect(find.text('Rafael'), findsOneWidget);
    expect(find.text('Pedro'), findsOneWidget);
    expect(find.byType(PlayerPosition), findsExactly(3));
    expect(find.byType(PlayerStatus), findsExactly(3));
    expect(find.byType(PlayerPhoto), findsExactly(3));
  });

  testWidgets('should present out section', (tester) async {
    await tester.pumpWidget(sut);
    presenter.emitNextEventWith(out: [
      NextEventPlayerViewModel(name: 'Rodrigo', initials: anyString()),
      NextEventPlayerViewModel(name: 'Rafael', initials: anyString()),
      NextEventPlayerViewModel(name: 'Pedro', initials: anyString())
    ]);
    await tester.pump();
    expect(find.text('FORA'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Rodrigo'), findsOneWidget);
    expect(find.text('Rafael'), findsOneWidget);
    expect(find.text('Pedro'), findsOneWidget);
    expect(find.byType(PlayerPosition), findsExactly(3));
    expect(find.byType(PlayerStatus), findsExactly(3));
    expect(find.byType(PlayerPhoto), findsExactly(3));
  });

  testWidgets('should present doubt section', (tester) async {
    await tester.pumpWidget(sut);
    presenter.emitNextEventWith(doubt: [
      NextEventPlayerViewModel(name: 'Rodrigo', initials: anyString()),
      NextEventPlayerViewModel(name: 'Rafael', initials: anyString()),
      NextEventPlayerViewModel(name: 'Pedro', initials: anyString())
    ]);
    await tester.pump();
    expect(find.text('DÚVIDA'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Rodrigo'), findsOneWidget);
    expect(find.text('Rafael'), findsOneWidget);
    expect(find.text('Pedro'), findsOneWidget);
    expect(find.byType(PlayerPosition), findsExactly(3));
    expect(find.byType(PlayerStatus), findsExactly(3));
    expect(find.byType(PlayerPhoto), findsExactly(3));
  });

  testWidgets('should hide all sections', (tester) async {
    await tester.pumpWidget(sut);
    presenter.emitNextEvent();
    await tester.pump();
    expect(find.text('DENTRO - GOLEIROS'), findsNothing);
    expect(find.text('DENTRO - JOGADORES'), findsNothing);
    expect(find.text('FORA'), findsNothing);
    expect(find.text('DÚVIDA'), findsNothing);
    expect(find.byType(PlayerPosition), findsNothing);
    expect(find.byType(PlayerStatus), findsNothing);
    expect(find.byType(PlayerPhoto), findsNothing);
  });

  testWidgets('should present error message on load error', (tester) async {
    await tester.pumpWidget(sut);
    presenter.emitError();
    await tester.pump();
    expect(find.text('DENTRO - GOLEIROS'), findsNothing);
    expect(find.text('DENTRO - JOGADORES'), findsNothing);
    expect(find.text('FORA'), findsNothing);
    expect(find.text('DÚVIDA'), findsNothing);
    expect(find.byType(PlayerPosition), findsNothing);
    expect(find.byType(PlayerStatus), findsNothing);
    expect(find.byType(PlayerPhoto), findsNothing);
    expect(find.text('Algo errado aconteceu, tente novamente.'), findsOneWidget);
    expect(find.text('RECARREGAR'), findsOneWidget);
  });

  testWidgets('should load event data on reload click', (tester) async {
    await tester.pumpWidget(sut);
    expect(presenter.callsCount, 1);
    expect(presenter.groupId, groupId);
    expect(presenter.isReload, false);
    presenter.emitError();
    await tester.pump();
    await tester.tap(find.text('RECARREGAR'));
    expect(presenter.callsCount, 2);
    expect(presenter.groupId, groupId);
    expect(presenter.isReload, true);
  });

  testWidgets('should handle spinner on page busy event', (tester) async {
    await tester.pumpWidget(sut);
    presenter.emitError();
    await tester.pump();
    presenter.emitIsBusy();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    presenter.emitIsBusy(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should load event data on pull to refresh', (tester) async {
    await tester.pumpWidget(sut);
    expect(presenter.callsCount, 1);
    expect(presenter.groupId, groupId);
    expect(presenter.isReload, false);
    presenter.emitNextEvent();
    await tester.pump();
    await tester.flingFrom(const Offset(50, 100), const Offset(0, 400), 800);
    await tester.pumpAndSettle();
    expect(presenter.callsCount, 2);
    expect(presenter.groupId, groupId);
    expect(presenter.isReload, true);
  });
}
