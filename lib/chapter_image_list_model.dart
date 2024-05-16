class ChapterImageListModel {
  final int? code;
  final List<Data>? data;

  ChapterImageListModel({
    this.code,
    this.data,
  });

  ChapterImageListModel.fromJson(Map<String, dynamic> json)
      : code = json['code'] as int?,
        data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'code' : code,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Data {
  final String? id;
  final String? chapter;
  final String? manga;
  final int? index;
  final String? link;

  Data({
    this.id,
    this.chapter,
    this.manga,
    this.index,
    this.link,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        chapter = json['chapter'] as String?,
        manga = json['manga'] as String?,
        index = json['index'] as int?,
        link = json['link'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'chapter' : chapter,
    'manga' : manga,
    'index' : index,
    'link' : link
  };
}