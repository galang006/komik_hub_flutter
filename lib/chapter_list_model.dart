class ChapterListModel {
  final int? code;
  final List<Data>? data;

  ChapterListModel({
    this.code,
    this.data,
  });

  ChapterListModel.fromJson(Map<String, dynamic> json)
      : code = json['code'] as int?,
        data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'code' : code,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Data {
  final String? id;
  final String? manga;
  final String? title;
  final int? createAt;
  final int? updateAt;

  Data({
    this.id,
    this.manga,
    this.title,
    this.createAt,
    this.updateAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        manga = json['manga'] as String?,
        title = json['title'] as String?,
        createAt = json['create_at'] as int?,
        updateAt = json['update_at'] as int?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'manga' : manga,
    'title' : title,
    'create_at' : createAt,
    'update_at' : updateAt
  };
}