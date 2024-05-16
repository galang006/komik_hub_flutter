import 'base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<Map<String, dynamic>> loadLatestKomik() {
    return BaseNetwork.get("/latest?page=1&nsfw=false");
  }

  Future<Map<String, dynamic>> loadKomik(String idKomik){
    return BaseNetwork.get("?id=$idKomik");
  }

  Future<Map<String, dynamic>> loadChapter(String idKomik){
    return BaseNetwork.get("/chapter?id=$idKomik");
  }

  Future<Map<String, dynamic>> loadChapterImage(String idChapter){
    return BaseNetwork.get("/image?id=$idChapter");
  }
}