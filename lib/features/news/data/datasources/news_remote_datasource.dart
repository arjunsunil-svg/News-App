import '../../../../core/graphql/graphql_queries.dart';
import '../../../../core/graphql/graphql_service.dart';
import '../../../../core/graphql/graphql_response.dart';
import '../models/article_model.dart';

class NewsRemoteDataSource {
  const NewsRemoteDataSource(this._graphqlService);

  final GraphQLService _graphqlService;

  Future<List<ArticleModel>>getNews() async {
    final response = await _graphqlService.query(
      GraphQLQueries.getNews,
    );

    final articles = response.data['articles'] as List<dynamic>;

    return articles
        .map(
        (article) => ArticleModel.fromGraphQL(
          article as Map<String, dynamic>,
        ),
    )
    .toList();
  }
}