abstract class NamedDataStorage {
  static late NamedDataStorage active;

  Future<Map<String, String>> readRegistry(String storeName);

  Future<bool> writeRegistry(String storeName, Map<String, String> registry);

  Future<String?> readData(String storeName, String dataId);

  Future<bool> writeData(String storeName, String dataId, String data);

  Future<bool> deleteData(String storeName, String dataId);
}
