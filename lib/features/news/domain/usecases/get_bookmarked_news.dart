import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class GetBookmarkedNews {
  const GetBookmarkedNews(this._repository);

  final NewsRepository _repository;

  Future<List<ArticleEntity>> call() {
    return _repository.getBookmarkedNews();
  }
}