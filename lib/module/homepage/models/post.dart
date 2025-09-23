class Data {
  final List<Post> posts;
  final int? total;
  final int? skip;
  final int? limit;

  Data({required this.posts, this.total, this.skip, this.limit});

  Data copyWith({List<Post>? posts, int? total, int? skip, int? limit}) => Data(
    posts: posts ?? this.posts,
    total: total ?? this.total,
    skip: skip ?? this.skip,
    limit: limit ?? this.limit,
  );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
    total: json["total"],
    skip: json["skip"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}

class Post {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;
  Reactions? reactions;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    this.reactions,
  });

  Post copyWith({
    int? id,
    String? title,
    String? body,
    int? userId,
    List<String>? tags,
    Reactions? reactions,
  }) => Post(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    userId: userId ?? this.userId,
    tags: tags ?? this.tags,
    reactions: reactions ?? this.reactions,
  );

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    title: json["title"],
    body: json["body"],
    userId: json["userId"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    reactions: json["reactions"] == null
        ? null
        : Reactions.fromJson(json["reactions"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "userId": userId,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "reactions": reactions,
  };
}

class Reactions {
  Reactions({required this.likes, required this.dislikes});

  final int? likes;
  final int? dislikes;

  Reactions copyWith({int? likes, int? dislikes}) {
    return Reactions(
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
    );
  }

  factory Reactions.fromJson(Map<String, dynamic> json) {
    return Reactions(likes: json["likes"], dislikes: json["dislikes"]);
  }

  Map<String, dynamic> toJson() => {"likes": likes, "dislikes": dislikes};

  @override
  String toString() {
    return "$likes, $dislikes, ";
  }
}
