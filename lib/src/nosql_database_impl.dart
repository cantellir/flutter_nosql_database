import 'package:nosql_database/src/nosql_database.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class NosqlDatabaseImpl implements NosqlDatabase {
  Database? _database;

  static final NosqlDatabaseImpl _nosqlDatabaseImpl = NosqlDatabaseImpl._();

  factory NosqlDatabaseImpl([Database? database]) {
    if (database != null) {
      _nosqlDatabaseImpl._database = database;
    }

    return _nosqlDatabaseImpl;
  }

  NosqlDatabaseImpl._();

  @override
  Future<void> init() async {
    if (_database == null) {
      final dir = await getApplicationDocumentsDirectory();

      await dir.create(recursive: true);

      final dbFile = join(dir.path, 'app_database.db');

      _database = await databaseFactoryIo.openDatabase(dbFile);
    }
  }

  @override
  Future<void> saveDocument(
      String storeKey, Map<String, Object> document) async {
    final store = intMapStoreFactory.store(storeKey);

    await store.add(_database!, document);
  }

  @override
  Future<Map<String, Object?>> loadFirstDocument(
      String storeKey, String fieldName, String fieldValue) async {
    final store = intMapStoreFactory.store(storeKey);
    final finder = Finder(filter: Filter.equals(fieldName, fieldValue));

    final result = await store.findFirst(_database!, finder: finder);
    return result != null ? result.value : {};
  }

  @override
  Future<List<Map<String, Object?>>> loadDocuments(String storeKey) async {
    final store = intMapStoreFactory.store(storeKey);
    final result = await store.find(_database!);
    return result.map((item) => item.value).toList();
  }

  @override
  Future<List<Map<String, Object?>>> loadDocumentsByFilter(
    String storeKey,
    String fieldName,
    String fieldValue,
  ) async {
    final store = intMapStoreFactory.store(storeKey);
    final finder = Finder(filter: Filter.equals(fieldName, fieldValue));
    final result = await store.find(_database!, finder: finder);
    return result.map((item) => item.value).toList();
  }

  @override
  Future<void> deleteByFilter(
    String storeKey,
    String fieldName,
    String fieldValue,
  ) async {
    final store = intMapStoreFactory.store(storeKey);
    final finder = Finder(filter: Filter.equals(fieldName, fieldValue));
    await store.delete(_database!, finder: finder);
  }
}
