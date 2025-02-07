import 'dart:io';

String makeApiUrl(String path) => 'http://${Platform.isIOS ? '127.0.0.1' : '10.0.2.2'}:8080/api/$path';
