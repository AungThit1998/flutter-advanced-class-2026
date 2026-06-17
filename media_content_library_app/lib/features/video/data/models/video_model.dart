import 'package:media_content_library_app/features/comments/data/models/comment_model.dart';

class VideoModel {
  VideoModel({this.total, this.page, this.limit, this.totalPages, this.data});

  VideoModel.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(VideoData.fromJson(v));
      });
    }
  }

  num? total;
  num? page;
  num? limit;
  num? totalPages;
  List<VideoData>? data;

  VideoModel copyWith({
    num? total,
    num? page,
    num? limit,
    num? totalPages,
    List<VideoData>? data,
  }) => VideoModel(
    total: total ?? this.total,
    page: page ?? this.page,
    limit: limit ?? this.limit,
    totalPages: totalPages ?? this.totalPages,
    data: data ?? this.data,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    map['totalPages'] = totalPages;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class VideoData {
  VideoData({
    this.id,
    this.type,
    this.title,
    this.source,
    this.url,
    this.thumbnail,
    this.duration,
    this.description,
    this.createdAt,
    this.comments,
  });

  VideoData.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    source = json['source'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    duration = json['duration'];
    description = json['description'];
    createdAt = json['createdAt'];
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments?.add(CommentModel.fromJson(v));
      });
    }
  }

  num? id;
  String? type;
  String? title;
  String? source;
  String? url;
  String? thumbnail;
  String? duration;
  String? description;
  String? createdAt;
  List<CommentModel>? comments;

  VideoData copyWith({
    num? id,
    String? type,
    String? title,
    String? source,
    String? url,
    String? thumbnail,
    String? duration,
    String? description,
    String? createdAt,
    List<CommentModel>? comments,
  }) => VideoData(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    source: source ?? this.source,
    url: url ?? this.url,
    thumbnail: thumbnail ?? this.thumbnail,
    duration: duration ?? this.duration,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
    comments: comments ?? this.comments,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['title'] = title;
    map['source'] = source;
    map['url'] = url;
    map['thumbnail'] = thumbnail;
    map['duration'] = duration;
    map['description'] = description;
    map['createdAt'] = createdAt;
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
