import '../entities/article_entity.dart';

abstract class NewsRepository {
  Future<List<ArticleEntity>> getNews();

  Future<void> bookmarkArticle(String articleId);

  Future<void> removeBookmark(String articleId);

  Future<List<ArticleEntity>> getBookmarkedNews();

  bool isBookmarked(String articleId);

  List<String> getBookmarkedIds();
}