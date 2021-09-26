import 'package:nosql_database/src/nosql_database.dart';
import 'package:nosql_database/src/nosql_database_impl.dart';
import 'package:sembast/sembast_memory.dart';

NosqlDatabase makeNosqlDatabase() => NosqlDatabaseImpl();

Future<NosqlDatabase> makeNosqlDatabaseInMemory() async {
  final factory = newDatabaseFactoryMemory();

  final db = await factory.openDatabase('test.db');

  return NosqlDatabaseImpl(db);
}
