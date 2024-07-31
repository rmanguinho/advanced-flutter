import 'dart:math';

int anyInt() => Random().nextInt(999999999);
String anyString() => anyInt().toString();
bool anyBool() => Random().nextBool();
DateTime anyDate() => DateTime.fromMillisecondsSinceEpoch(anyInt());
String anyIsoDate() => DateTime.fromMillisecondsSinceEpoch(anyInt()).toIso8601String();
