import 'package:advanced_flutter/infra/api/adapters/http_adapter.dart';

import 'package:http/http.dart';

HttpAdapter makeHttpAdapter() {
  return HttpAdapter(client: Client());
}
