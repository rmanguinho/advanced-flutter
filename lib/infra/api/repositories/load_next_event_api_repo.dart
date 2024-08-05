import 'package:advanced_flutter/domain/entities/errors.dart';
import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/api/clients/http_get_client.dart';
import 'package:advanced_flutter/infra/mappers/next_event_mapper.dart';

final class LoadNextEventApiRepository {
  final HttpGetClient httpClient;
  final String url;

  const LoadNextEventApiRepository({
    required this.httpClient,
    required this.url
  });

  Future<NextEvent> loadNextEvent({ required String groupId }) async {
    final json = await httpClient.get(url: url, params: { "groupId": groupId });
    if (json == null) throw UnexpectedError();
    return NextEventMapper().toObject(json);
  }
}
