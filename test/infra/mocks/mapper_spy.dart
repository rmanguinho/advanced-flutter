import 'package:advanced_flutter/infra/mappers/mapper.dart';
import 'package:advanced_flutter/infra/types/json.dart';

import '../../mocks/fakes.dart';

final class MapperSpy<Dto> implements Mapper<Dto> {
  Json? toDtoIntput;
  int toDtoIntputCallsCount = 0;
  int toJsonCallsCount = 0;
  Dto toDtoOutput;
  Dto? toJsonIntput;
  Json toJsonOutput = anyJson();

  MapperSpy({
    required this.toDtoOutput
  });

  @override
  Dto toDto(Json json) {
    toDtoIntput = json;
    toDtoIntputCallsCount++;
    return toDtoOutput;
  }

  @override
  Json toJson(Dto dto) {
    toJsonIntput = dto;
    toJsonCallsCount++;
    return toJsonOutput;
  }
}
