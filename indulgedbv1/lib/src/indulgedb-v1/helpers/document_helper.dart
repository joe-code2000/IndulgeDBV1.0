import 'package:indulgedbv1/src/indulgedb-v1/addons/nosql_utilities.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/sub_components/document.dart';

class DocumentHelper {
  final NoSQLUtility _noSQLUtility = NoSQLUtility();

  Future<bool> insertDocuments({
    required String reference,
    required List<Map<String, dynamic>> data,
  }) async {
    return await _noSQLUtility.insertDocuments(
      reference: reference,
      data: data,
    );
  }

  Future<List<Document>> getDocuments({
    required String reference,
    bool Function(Document document)? query,
  }) async {
    return await _noSQLUtility.getDocuments(
      reference: reference,
      query: query,
    );
  }

  Stream<List<Document>> getDocumentStream({
    required String reference,
    bool Function(Document document)? query,
  }) async* {
    yield* _noSQLUtility.getDocumentStream(
      reference: reference,
      query: query,
    );
  }

  Future<bool> updateDocuments({
    required String reference,
    required bool Function(Document document) query,
    required Map<String, dynamic> data,
  }) async {
    return await _noSQLUtility.updateDocuments(
      reference: reference,
      query: query,
      data: data,
    );
  }

  Future<bool> removeDocuments({
    required String reference,
    required bool Function(Document document) query,
  }) async {
    return await _noSQLUtility.removeDocuments(
      reference: reference,
      query: query,
    );
  }
}
