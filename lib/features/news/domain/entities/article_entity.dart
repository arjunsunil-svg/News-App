class ArticleEntity {
  const ArticleEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.url,
    required this.categories,
  });
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final DateTime publishedAt;
  final String url;
  final List<String> categories;
}