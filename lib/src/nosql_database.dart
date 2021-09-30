abstract class NosqlDatabase {
  Future<void> init();
  Future<void> saveDocument(String storeKey, Map<String, Object> document);
  Future<Map<String, Object?>> loadFirstDocument(
    String storeKey,
    String fieldName,
    String fieldValue,
  );
  Future<List<Map<String, Object?>>> loadDocuments(String storeKey);
  Future<List<Map<String, Object?>>> loadDocumentsByFilter(
    String storeKey,
    String fieldName,
    String fieldValue,
  );
  Future<void> updateDocumentsByFilter(
    String storeKey,
    Map<String, Object> document,
    String fieldName,
    String fieldValue,
  );
  Future<void> deleteDocumentsByFilter(
    String storeKey,
    String fieldName,
    String fieldValue,
  );
}
