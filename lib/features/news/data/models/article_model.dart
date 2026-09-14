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
    required super.content,
    required super.lang,
    required super.categories,
    required super.sourceUrl,
    required super.sourceCountry,
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
      content: json['content'] as String? ?? '',
      lang: json['lang'] as String? ?? '',
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
      sourceUrl: source['url'] as String? ?? '',
      sourceCountry: source['country'] as String? ?? '',
    );
  }
}