import 'package:indulgedbv1/src/indulgedb-v1/addons/nosql_transactional/nosql_transactional.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/nosql_database.dart';
import 'package:indulgedbv1/src/indulgedb-v1/nosql_manager.dart';

class NoSQLTransactionalManager {
  NoSQLTransactional? _currentTransactional;

  final NoSQLManager _noSqlManager = NoSQLManager();

  NoSQLTransactionalManager._();
  static final _intance = NoSQLTransactionalManager._();
  factory NoSQLTransactionalManager() => _intance;

  NoSQLTransactional? get currentTransactional => _currentTransactional;

  Future<int> mount(
    NoSQLTransactional noSQLTransactional,
    void Function(NoSQLDatabase noSQLDatabase) setDatabase,
  ) async {
    try {
      if (_currentTransactional == null) {
        _currentTransactional = noSQLTransactional;

        var db = NoSQLDatabase.copy(
          initialDB: _noSqlManager.getNoSqlDatabase(),
        );

        setDatabase(db);

        return 1;
      }

      return 0;
    } catch (_) {}
    return -1;
  }

  Future<int> unmount(NoSQLTransactional noSQLTransactional) async {
    if (_currentTransactional == noSQLTransactional) {
      _currentTransactional = null;
      return 1;
    }

    return 0;
  }

  Future<bool> commit(NoSQLDatabase db) async {
    return _noSqlManager.setNoSqlDatabase(db);
  }
}
