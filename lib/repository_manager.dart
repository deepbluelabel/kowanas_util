
import 'repository.dart';

class RepositoryManager{
  final repositories = Map<String, Repository>();
  add<T>(repository) => repositories[T.toString()] = repository;
  get<T>() => repositories[T.toString()];

  init() async{
    for (final repository in repositories.values)
      await repository.init();
  }
}