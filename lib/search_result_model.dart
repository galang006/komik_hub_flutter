class SearchResultListModel {
  final int? code;
  final List<Data>? data;

  SearchResultListModel({
    this.code,
    this.data,
  });

  SearchResultListModel.fromJson(Map<String, dynamic> json)
      : code = json['code'] as int?,
        data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'code' : code,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Data {
  final String? id;
  final String? title;
  final String? subTitle;
  final String? status;
  final String? thumb;
  final String? summary;
  final List<String>? authors;
  final List<String>? genres;
  final bool? nsfw;
  final String? type;
  final int? totalChapter;
  final int? createAt;
  final int? updateAt;

  Data({
    this.id,
    this.title,
    this.subTitle,
    this.status,
    this.thumb,
    this.summary,
    this.authors,
    this.genres,
    this.nsfw,
    this.type,
    this.totalChapter,
    this.createAt,
    this.updateAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        title = json['title'] as String?,
        subTitle = json['sub_title'] as String?,
        status = json['status'] as String?,
        thumb = json['thumb'] as String?,
        summary = json['summary'] as String?,
        authors = (json['authors'] as List?)?.map((dynamic e) => e as String).toList(),
        genres = (json['genres'] as List?)?.map((dynamic e) => e as String).toList(),
        nsfw = json['nsfw'] as bool?,
        type = json['type'] as String?,
        totalChapter = json['total_chapter'] as int?,
        createAt = json['create_at'] as int?,
        updateAt = json['update_at'] as int?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title,
    'sub_title' : subTitle,
    'status' : status,
    'thumb' : thumb,
    'summary' : summary,
    'authors' : authors,
    'genres' : genres,
    'nsfw' : nsfw,
    'type' : type,
    'total_chapter' : totalChapter,
    'create_at' : createAt,
    'update_at' : updateAt
  };
}