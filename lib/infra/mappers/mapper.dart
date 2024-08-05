abstract base class Mapper<Entity> {
  List<Entity> toList(dynamic arr) => arr.map<Entity>(toObject).toList();
  Entity toObject(dynamic json);
}
