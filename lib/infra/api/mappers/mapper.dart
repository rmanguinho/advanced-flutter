import 'package:advanced_flutter/infra/types/json.dart';

abstract base class Mapper<Entity> {
  List<Entity> toList(JsonArr arr) => arr.map(toObject).toList();

  Entity toObject(Json json);
}
