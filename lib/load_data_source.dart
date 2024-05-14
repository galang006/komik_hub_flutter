import 'base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<Map<String, dynamic>> loadLatestKomik() {
    return BaseNetwork.get("latest?page=1&nsfw=false");
  }
}