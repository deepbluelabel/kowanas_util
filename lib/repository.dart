typedef Where = bool Function(dynamic e);
abstract class Repository{
  final db;

  Repository({this.db});

  connect(name) => db.connect(name);

  getAll() => db.read();

  add(item) => db.add(item);

  remove(item) => db.delete(item);

  get(Where where){
    return db.read().where((e)=>where(e));
  }

  get isEmpty => db.read().isEmpty;

  update(item) => db.update(item);

  init(){}
}