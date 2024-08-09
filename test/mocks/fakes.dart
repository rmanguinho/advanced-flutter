import 'dart:math';

import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/infra/types/json.dart';

int anyInt([int max = 999999999]) => Random().nextInt(max);
String anyString() => anyInt().toString();
bool anyBool() => Random().nextBool();
DateTime anyDate() => DateTime.fromMillisecondsSinceEpoch(anyInt());
String anyIsoDate() => DateTime.fromMillisecondsSinceEpoch(anyInt()).toIso8601String();
Json anyJson() => { anyString(): anyString() };
JsonArr anyJsonArr() => List.generate(anyInt(5), (index) => anyJson());
NextEventPlayer anyNextEventPlayer() => NextEventPlayer(id: anyString(), name: anyString(), isConfirmed: anyBool());
List<NextEventPlayer> anyNextEventPlayerList() => List.generate(anyInt(5), (index) => anyNextEventPlayer());
