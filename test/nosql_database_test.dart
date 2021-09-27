import 'package:flutter_test/flutter_test.dart';

import 'package:nosql_database/src/nosql_database_impl.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

void main() {
  late NosqlDatabaseImpl sut;
  late Database db;

  final fruitsStore = 'fruitsStore';
  final animalsStore = 'animalsStore';

  final firstFruit = {
    'id': '1',
    'name': 'lemon',
    'color': 'green',
  };

  final secondFruit = {
    'id': '2',
    'name': 'orange',
    'color': 'orange',
  };

  final firstAnimal = {
    'id': '1',
    'family': 'mammal',
    'name': 'dog',
    'hasTail': true,
  };

  final secondAnimal = {
    'id': '2',
    'family': 'bird',
    'name': 'eagle',
    'hasTail': false,
  };

  final thirdAnimal = {
    'id': '3',
    'family': 'mammal',
    'name': 'cat',
    'hasTail': true,
  };

  setUp(() {
    return Future(() async {
      final factory = newDatabaseFactoryMemory();

      db = await factory.openDatabase('test.db');

      sut = NosqlDatabaseImpl(db);
    });
  });

  test('Should return a unique instance of NosqlDatabase', () async {
    final anotherNosqlDatabaseImlp = NosqlDatabaseImpl();

    expect(identical(sut, anotherNosqlDatabaseImlp), true);
  });

  test('should load saved fruit map', () async {
    await sut.saveDocument(fruitsStore, firstFruit);
    final fruit = await sut.loadFirstDocument(fruitsStore, 'id', '1');
    expect(fruit, firstFruit);
  });

  test('should return the correct saved values', () async {
    await sut.saveDocument(fruitsStore, firstFruit);
    await sut.saveDocument(fruitsStore, secondFruit);
    await sut.saveDocument(animalsStore, firstAnimal);
    await sut.saveDocument(animalsStore, secondAnimal);

    final savedFirstFruit = await sut.loadFirstDocument(fruitsStore, 'id', '1');
    final savedSecondFruit =
        await sut.loadFirstDocument(fruitsStore, 'id', '2');
    final savedFirstAnimal =
        await sut.loadFirstDocument(animalsStore, 'id', '1');
    final savedSecondAnimal =
        await sut.loadFirstDocument(animalsStore, 'id', '2');

    expect(savedFirstFruit, firstFruit);
    expect(savedSecondFruit, secondFruit);
    expect(savedFirstAnimal, firstAnimal);
    expect(savedSecondAnimal, secondAnimal);
  });

  test('should return a list of saved maps', () async {
    await sut.saveDocument(fruitsStore, firstFruit);
    await sut.saveDocument(fruitsStore, secondFruit);
    final result = await sut.loadDocuments(fruitsStore);
    expect(result, [firstFruit, secondFruit]);
  });

  test('should return a correct filtered list of saved maps', () async {
    await sut.saveDocument(animalsStore, firstAnimal);
    await sut.saveDocument(animalsStore, secondAnimal);
    await sut.saveDocument(animalsStore, thirdAnimal);
    final result =
        await sut.loadDocumentsByFilter(animalsStore, 'family', 'mammal');

    expect(result, [firstAnimal, thirdAnimal]);
  });

  test('should delete the correct map', () async {
    await sut.saveDocument(animalsStore, firstAnimal);
    await sut.saveDocument(animalsStore, secondAnimal);
    await sut.saveDocument(animalsStore, thirdAnimal);

    await sut.deleteByFilter(animalsStore, 'id', '1');

    final result = await sut.loadDocuments(animalsStore);

    expect(result, [secondAnimal, thirdAnimal]);
  });

  test('should delete a list of map by filter', () async {
    await sut.saveDocument(animalsStore, firstAnimal);
    await sut.saveDocument(animalsStore, secondAnimal);
    await sut.saveDocument(animalsStore, thirdAnimal);

    await sut.deleteByFilter(animalsStore, 'family', 'mammal');

    final result = await sut.loadDocuments(animalsStore);

    expect(result, [secondAnimal]);
  });

  test(
      'should return an empty list when load documents and '
      'there is no saved data', () async {
    final result = await sut.loadDocuments(animalsStore);

    expect(result.isEmpty, true);
  });

  test(
      'should return an empty list when load documents by filter and '
      'there is no saved data', () async {
    final result =
        await sut.loadDocumentsByFilter(animalsStore, 'family', 'mammal');

    expect(result.isEmpty, true);
  });

  test(
      'should return an empty map when load first document and '
      'there is saved data', () async {
    final result = await sut.loadFirstDocument(animalsStore, 'id', '1');

    expect(result.isEmpty, true);
  });

  tearDown(() => db.close);
}
