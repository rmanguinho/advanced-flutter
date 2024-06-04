abstract interface class HttpGetClient {
  Future<T?> get<T>({ required String url, Map<String, String>? headers, Map<String, String?>? params, Map<String, String>? queryString });
}
