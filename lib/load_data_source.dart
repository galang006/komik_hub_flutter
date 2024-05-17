import 'base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<Map<String, dynamic>> loadLatestKomik(String page) {
    return BaseNetwork.get("/latest?page=$page&nsfw=false");
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

  Future<Map<String, dynamic>> loadSearchResult(String text){
    return BaseNetwork.get("/search?text=$text&nsfw=true&type=all");
  }
}