import '../repositories/news_repository.dart';

class BookmarkArticle {
  const BookmarkArticle(this._repository);

  final NewsRepository _repository;

  Future<void> call(String articleId) {
    return _repository.bookmarkArticle(articleId);
  }
}