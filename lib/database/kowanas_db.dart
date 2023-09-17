abstract class KowanasDB{
  connect(name, adapter);
  add(record);
  read({where});
  update(record);
  delete(record);
}