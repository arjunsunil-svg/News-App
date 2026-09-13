import '../../domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.author,
    required super.publishedAt,
    required super.url,
  });

  factory ArticleModel.fromGraphQL(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>;

    return ArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image'] as String,
      author: source['name'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      url: json['url'] as String,
    );
  }
}