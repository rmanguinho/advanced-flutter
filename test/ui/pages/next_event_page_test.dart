import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
    return const Scaffold();
  }
}

abstract class NextEventPresenter {
  void loadNextEvent({ required String groupId });
}

final class NextEventPresenterSpy implements NextEventPresenter {
  int loadCallsCount = 0;
  String? groupId;

  @override
  void loadNextEvent({ required String groupId }) {
    loadCallsCount++;
    this.groupId = groupId;
  }
}

void main() {
  testWidgets('should load event data on page init', (tester) async {
    final presenter = NextEventPresenterSpy();
    final groupId = anyString();
    final sut = MaterialApp(home: NextEventPage(presenter: presenter, groupId: groupId));
    await tester.pumpWidget(sut);
    expect(presenter.loadCallsCount, 1);
    expect(presenter.groupId, groupId);
  });
}
