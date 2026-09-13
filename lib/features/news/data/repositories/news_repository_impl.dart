import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_datasource.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl(
      this._remoteDataSource,
      this._localDataSource,
      );

  final NewsRemoteDataSource _remoteDataSource;
  final NewsLocalDataSource _localDataSource;

  @override
  Future<List<ArticleEntity>> getNews() {
    return _remoteDataSource.getNews();
  }

  @override
  Future<void> bookmarkArticle(String articleId) {
    return _localDataSource.addBookmark(articleId);
  }

  @override
  Future<void> removeBookmark(String articleId) {
    return _localDataSource.removeBookmark(articleId);
  }

  @override
  Future<List<ArticleEntity>> getBookmarkedNews() async {
    final articles = await _remoteDataSource.getNews();

    final bookmarkedIds = _localDataSource.getBookmarkedIds();

    return articles
        .where((article) => bookmarkedIds.contains(article.id))
        .toList();
  }

  @override
  bool isBookmarked(String articleId) {
    return _localDataSource.isBookmarked(articleId);
  }

  @override
  List<String> getBookmarkedIds() {
    return _localDataSource.getBookmarkedIds();
  }
}