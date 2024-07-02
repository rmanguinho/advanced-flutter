import 'package:advanced_flutter/main/factories/infra/api/repositories/load_next_event_api_repo_factory.dart';
import 'package:advanced_flutter/presentation/rx/next_event_rx_presenter.dart';
import 'package:advanced_flutter/ui/pages/next_event_page.dart';

import 'package:flutter/material.dart';

Widget makeNextEventPage() {
  final repo = makeLoadNextEventApiRepository();
  final presenter = NextEventRxPresenter(nextEventLoader: repo.loadNextEvent);
  return NextEventPage(presenter: presenter, groupId: 'valid_id');
}
