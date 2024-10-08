import 'package:indulgedbv1/src/indulgedb-v1/addons/nosql_utilities.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/meta/components/sub_components/restriction_object.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/sub_components/collection.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/sub_components/database.dart';

class CollectionHelper {
  final NoSQLUtility _noSQLUtility = NoSQLUtility();

  Future<bool> setRestrictions({
    required String reference,
    required RestrictionBuilder builder,
  }) async {
    return await _noSQLUtility.setRestrictions(
      reference: reference,
      builder: builder,
    );
  }

  Future<bool> removeRestrictions({
    required String reference,
    List<String> fieldObjectKeys = const [],
    List<String> valueObjectKeys = const [],
  }) async {
    return await _noSQLUtility.removeRestrictions(
      reference: reference,
      fieldObjectKeys: fieldObjectKeys,
      valueObjectKeys: valueObjectKeys,
    );
  }

  Future<bool> createCollection({
    required String reference,
  }) async {
    return await _noSQLUtility.createCollection(reference: reference);
  }

  Future<Collection?> getCollection({
    required String reference,
  }) async {
    return await _noSQLUtility.getCollection(reference: reference);
  }

  Future<List<Collection>> getCollections({
    String? databaseName,
    bool Function(Database database)? query,
  }) async {
    return await _noSQLUtility.getCollections(
      databaseName: databaseName,
      query: query,
    );
  }

  Stream<List<Collection>> getCollectionStream({
    String? databaseName,
    bool Function(Collection collection)? query,
  }) async* {
    yield* _noSQLUtility.getCollectionStream(
      databaseName: databaseName,
      query: query,
    );
  }

  Future<bool> updateCollection({
    required String reference,
    required Map<String, dynamic> data,
  }) async {
    return await _noSQLUtility.updateCollection(
      reference: reference,
      data: data,
    );
  }

  Future<bool> removeCollection({
    required String reference,
  }) async {
    return await _noSQLUtility.removeCollection(reference: reference);
  }
}
