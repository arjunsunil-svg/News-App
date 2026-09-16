import '../../../../core/graphql/graphql_service.dart';
import '../../../../core/graphql/post_graphql_mutations.dart';
import '../models/post_model.dart';

class PostRemoteDataSource {
  const PostRemoteDataSource(this._graphqlService);

  final GraphQLService _graphqlService;

  Future<PostModel> createPost({
    required String title,
    required String body,
  }) async {
    final response = await _graphqlService.mutate(
      PostGraphQLMutations.createPost,
      variables: {
        'title': title,
        'body': body,
      },
    );

    final data = response.data['createPost'] as Map<String, dynamic>;

    return PostModel.fromGraphQL(data);
  }
}