import 'graphql_executor.dart';
import 'graphql_json_executor.dart';
import 'graphql_response.dart';

class GraphQLService {
  GraphQLService({GraphQLExecutor? executor})
      : _executor = executor ?? GraphQLJsonExecutor.instance;

  final GraphQLExecutor _executor;

  Future<GraphQLResponse> query(
      String document, {
        Map<String, dynamic>? variables,
      }) async {
    final data = await _executor.execute(
      document,
      variables ?? const {},
    );

    return GraphQLResponse(
        data: data
    );
  }

  Future<GraphQLResponse> mutate(
      String document, {
        Map<String, dynamic>? variables,
      }) async {
    final data = await _executor.execute(
      document,
      variables ?? const {},
    );

    return GraphQLResponse(
        data: data
    );
  }
}