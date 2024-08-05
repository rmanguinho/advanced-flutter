import 'package:advanced_flutter/infra/types/json.dart';

abstract interface class DtoMapper<Dto> {
  Dto toDto(Json json);
}

abstract interface class JsonMapper<Dto> {
  Json toJson(Dto dto);
}

abstract interface class Mapper<Dto> implements DtoMapper<Dto>, JsonMapper<Dto> {}

mixin DtoListMapper<Dto> implements DtoMapper<Dto> {
  List<Dto> toDtoList(dynamic arr) => arr.map<Dto>(toDto).toList();
}

mixin JsonArrMapper<Dto> implements JsonMapper<Dto> {
  JsonArr toJsonArr(List<Dto> list) => list.map(toJson).toList();
}

abstract base class ListMapper<Dto> with DtoListMapper<Dto>, JsonArrMapper<Dto> {}
