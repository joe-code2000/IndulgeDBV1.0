import 'package:indulgedbv1/src/indulgedb-v1/addons/datastructures/chains/unidirectional_chain.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/base_component.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/events.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/meta/components/sub_components/restriction_object.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/sub_components/collection.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/sub_components/document.dart';
import 'package:indulgedbv1/src/indulgedb-v1/nosql_manager.dart';
import 'package:indulgedbv1/src/indulgedb-v1/utilities.dart';

mixin NoSqlDocumentProxy {
  final EventStreamWrapper _streamWrapper = EventStreamWrapper();

  RestrictionBuilder? getFieldObjectsByCollection({
    required Collection collection,
  }) {
    return NoSQLManager()
        .getNoSqlDatabase()
        .metaManger
        .metaRestrictionObject
        .getRestrictionBuilder(
          objectId: collection.objectId,
        );
  }

  List<Map<String, dynamic>> generateDocumentList({
    required Collection collection,
  }) {
    return collection.objects.values
        .map(
          (e) => e.toJson(
            serialize: false,
          ),
        )
        .toList();
  }

  bool fieldValidator({
    required Map<String, dynamic> data,
    required List<RestrictionFieldObject> objects,
    List<Map<String, dynamic>> dataList = const [],
    String? specificKey,
  }) {
    bool results = true;

    for (var object in objects) {
      results = object.validate(
        json: data,
        dataList: dataList,
        specificKey: specificKey,
      );
      if (!results) {
        return false;
      }
    }

    return results;
  }

  bool valueValidator({
    required Map<String, dynamic> data,
    required List<RestrictionValueObject> objects,
  }) {
    bool results = true;

    for (var object in objects) {
      results = object.validate(
        json: data,
      );
      if (!results) {
        return false;
      }
    }

    return results;
  }

  bool insertDocumentsProxy({
    required Collection collection,
    required List<Map<String, dynamic>> data,
  }) {
    bool results = true;

    var builder = getFieldObjectsByCollection(collection: collection);

    for (var field in data) {
      var dataList = generateDocumentList(collection: collection);

      bool res = UnidirectionalChain().addBlock(
        block: () {
          return fieldValidator(
            data: field,
            objects: builder?.fieldObjectsList ?? [],
            dataList: dataList,
            specificKey: "fields",
          );
        },
      ).addBlock(
        block: () {
          return valueValidator(
            data: field,
            objects: builder?.valueObjectsList ?? [],
          );
        },
      ).addBlock(
        block: () {
          Document document = Document(
            objectId: generateUUID(10000),
            timestamp: DateTime.now(),
          );
          document.addField(field: field);

          bool res = collection.addDocument(document: document);

          if (res) {
            _streamWrapper.broadcastEventStream<Document>(
              eventNotifier: EventNotifier(
                event: EventType.add,
                entityType: EntityType.document,
                object: document,
              ),
            );
          }

          return res;
        },
      ).execute();

      if (!res) {
        results = false;
      }
    }

    return results;
  }

  bool updateDocumentsProxy({
    required Collection collection,
    required bool Function(Document document) query,
    required Map<String, dynamic> data,
  }) {
    List<Document> documents = collection.objects.values
        .where(
          query,
        )
        .toList();

    var builder = getFieldObjectsByCollection(collection: collection);

    var dataList = generateDocumentList(collection: collection);

    bool results = UnidirectionalChain().addBlock(
      block: () {
        return fieldValidator(
          data: data,
          objects: builder?.fieldObjectsList ?? [],
          dataList: dataList,
          specificKey: "fields",
        );
      },
    ).addBlock(
      block: () {
        return valueValidator(
          data: data,
          objects: builder?.valueObjectsList ?? [],
        );
      },
    ).addBlock(
      block: () {
        bool results = true;
        for (var document in documents) {
          bool res = collection.updateDocument(
            document: document,
            data: data,
          );
          if (!res) {
            results = false;
            continue;
          }

          _streamWrapper.broadcastEventStream<Document>(
            eventNotifier: EventNotifier(
              event: EventType.update,
              entityType: EntityType.document,
              object: document,
            ),
          );
        }
        return results;
      },
    ).execute();

    return results;
  }
}
