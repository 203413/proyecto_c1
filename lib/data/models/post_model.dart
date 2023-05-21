import '../../domain/entities/post.dart';

class PostModel extends Post {
  PostModel({required int id, required String name, required String des})
      : super(id: id, name: name, des: des);

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(id: json['id'], name: json['name'], des: json['des']);
  }

  factory PostModel.fromEntity(Post post) {
    return PostModel(id: post.id, name: post.name, des: post.des);
  }
}
