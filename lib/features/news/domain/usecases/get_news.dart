import '../repositories/news_repository.dart';
import '../entities/article_entity.dart';

class GetNews {
  const GetNews(this._repository);

  final NewsRepository _repository;

  Future<List<ArticleEntity>> call() {
    print('2. GetNews: call() started');
    return _repository.getNews();
  }
}
