import 'package:indulgedbv1/src/indulgedb-v1/addons/nosql_utilities.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/sub_components/database.dart';

class DatabaseHelper {
  final NoSQLUtility _noSQLUtility = NoSQLUtility();

  Future<bool> setCurrentDatabase({String? name}) async {
    return await _noSQLUtility.setCurrentDatabase(name: name);
  }

  Future<bool> createDatabase({
    required String name,
  }) async {
    return await _noSQLUtility.createDatabase(name: name);
  }

  Future<Database?> getDatabase({
    required String reference,
  }) async {
    return await _noSQLUtility.getDatabase(reference: reference);
  }

  Future<List<Database>> getDatabases({
    bool Function(Database database)? query,
  }) async {
    return await _noSQLUtility.getDatabases(query: query);
  }

  Stream<List<Database>> getDatabaseStream({
    bool Function(Database database)? query,
  }) async* {
    yield* _noSQLUtility.getDatabaseStream(query: query);
  }

  Future<bool> updateDatabase({
    required String name,
    required Map<String, dynamic> data,
  }) async {
    return await _noSQLUtility.updateDatabase(name: name, data: data);
  }

  Future<bool> removeDatabase({
    required String name,
  }) async {
    return await _noSQLUtility.removeDatabase(name: name);
  }
}
