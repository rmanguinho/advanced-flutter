import 'dart:math';

String anyString() => Random().nextInt(999999999).toString();
bool anyBool() => Random().nextBool();
DateTime anyDate() => DateTime.fromMillisecondsSinceEpoch(Random().nextInt(999999999));
