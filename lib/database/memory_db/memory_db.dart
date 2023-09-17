
import 'package:kowanas_util/database/kowanas_db.dart';

class MemoryDB<T> extends KowanasDB{
  final records = <T>[];

  @override
  read({where}) {
    return records;
  }

  @override
  bool add(record) {
    if(_isExist(record) == false) {
      records.add(record);
      return true;
    }
    return false;
  }

  _isExist(record) => records.any((e)=>e==record);

  @override
  connect(name, adapter) {}

  @override
  delete(record) {}

  @override
  update(record) {}
}