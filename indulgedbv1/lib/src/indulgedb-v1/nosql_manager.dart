import 'package:indulgedbv1/src/indulgedb-v1/addons/meta/proxies/nosql_document_proxy.dart';
import 'package:indulgedbv1/src/indulgedb-v1/addons/nosql_transactional/nosql_transactional_manager.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/base_component.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/events.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/nosql_database.dart';
import 'package:indulgedbv1/src/indulgedb-v1/core/components/sub_components/collection.dart';
import 'package:indulgedbv1/src/indulgedb-v1/utilities.dart';

class NoSQLManager with NoSqlDocumentProxy {
  final double _version = 1.0;
  final EventStream _eventStream = EventStream();

  NoSQLDatabase noSQLDatabase = NoSQLDatabase(
    objectId: generateUUID(10000),
  );

  NoSQLManager._() {
    _eventStream.eventStream.listen(
      (event) {
        switch (event.event) {
          case EventType.add:
            break;
          case EventType.update:
            break;
          case EventType.remove:
            if (event.entityType == EntityType.collection) {
              var obj = event.object as Collection;
              getNoSqlDatabase()
                  .metaManger
                  .metaRestrictionObject
                  .removeCollectionRestriction(
                    objectId: obj.objectId,
                  );
            }
            break;
          default:
        }
      },
    );
  }
  static final _instance = NoSQLManager._();
  factory NoSQLManager() => _instance;

  void initialize({required Map<String, dynamic> data}) {
    noSQLDatabase.initialize(data: data["noSQLDatabase"]);
  }

  NoSQLDatabase getNoSqlDatabase() {
    NoSQLTransactionalManager transactionalManager =
        NoSQLTransactionalManager();

    var transactional = transactionalManager.currentTransactional;

    if (transactional != null) {
      return transactional.noSQLDatabase ?? noSQLDatabase;
    }
    return noSQLDatabase;
  }

  bool setNoSqlDatabase(NoSQLDatabase db) {
    bool results = true;

    results = noSQLDatabase.commit(
      data: db.toJson(serialize: false)["objects"],
    );

    return results;
  }

  Future<bool> opMapper({required Future<bool> Function() func}) async {
    NoSQLTransactionalManager transactionalManager =
        NoSQLTransactionalManager();

    var transactional = transactionalManager.currentTransactional;

    if (transactional != null) {
      if (!transactional.getExecutionResults()) {
        return false;
      }

      bool results = await func();

      await transactional.setExecutionResults(results);

      return results;
    }

    return await func();
  }

  Map<String, dynamic> toJson({
    required bool serialize,
  }) {
    return {
      "version": _version,
      "noSQLDatabase": serialize
          ? noSQLDatabase.toJson(serialize: serialize)
          : noSQLDatabase,
    };
  }
}
