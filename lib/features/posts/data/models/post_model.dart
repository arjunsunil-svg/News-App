import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
  });

  factory PostModel.fromGraphQL(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}