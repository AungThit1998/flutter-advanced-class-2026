class PdfModel {
  PdfModel({this.total, this.page, this.limit, this.totalPages, this.data});

  PdfModel.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PdfData.fromJson(v));
      });
    }
  }

  num? total;
  num? page;
  num? limit;
  num? totalPages;
  List<PdfData>? data;

  PdfModel copyWith({
    num? total,
    num? page,
    num? limit,
    num? totalPages,
    List<PdfData>? data,
  }) => PdfModel(
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

class PdfData {
  PdfData({
    this.id,
    this.type,
    this.title,
    this.url,
    this.previewImage,
    this.fileSize,
    this.pages,
    this.createdAt,
    this.comments,
  });

  PdfData.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    url = json['url'];
    previewImage = json['previewImage'];
    fileSize = json['fileSize'];
    pages = json['pages'];
    createdAt = json['createdAt'];
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments?.add(Comments.fromJson(v));
      });
    }
  }

  num? id;
  String? type;
  String? title;
  String? url;
  String? previewImage;
  String? fileSize;
  num? pages;
  String? createdAt;
  List<Comments>? comments;

  PdfData copyWith({
    num? id,
    String? type,
    String? title,
    String? url,
    String? previewImage,
    String? fileSize,
    num? pages,
    String? createdAt,
    List<Comments>? comments,
  }) => PdfData(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    url: url ?? this.url,
    previewImage: previewImage ?? this.previewImage,
    fileSize: fileSize ?? this.fileSize,
    pages: pages ?? this.pages,
    createdAt: createdAt ?? this.createdAt,
    comments: comments ?? this.comments,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['title'] = title;
    map['url'] = url;
    map['previewImage'] = previewImage;
    map['fileSize'] = fileSize;
    map['pages'] = pages;
    map['createdAt'] = createdAt;
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Comments {
  Comments({
    this.id,
    this.user,
    this.userId,
    this.text,
    this.createdAt,
    this.isOwn,
  });

  Comments.fromJson(dynamic json) {
    id = json['id'];
    user = json['user'];
    userId = json['userId'];
    text = json['text'];
    createdAt = json['createdAt'];
    isOwn = json['isOwn'];
  }

  num? id;
  String? user;
  num? userId;
  String? text;
  String? createdAt;
  bool? isOwn;

  Comments copyWith({
    num? id,
    String? user,
    num? userId,
    String? text,
    String? createdAt,
    bool? isOwn,
  }) => Comments(
    id: id ?? this.id,
    user: user ?? this.user,
    userId: userId ?? this.userId,
    text: text ?? this.text,
    createdAt: createdAt ?? this.createdAt,
    isOwn: isOwn ?? this.isOwn,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user'] = user;
    map['userId'] = userId;
    map['text'] = text;
    map['createdAt'] = createdAt;
    map['isOwn'] = isOwn;
    return map;
  }
}
