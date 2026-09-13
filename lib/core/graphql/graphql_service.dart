import 'graphql_json_executor.dart';
import 'graphql_response.dart';

class GraphQLService {
  GraphQLService();

  final _executor = GraphQLJsonExecutor.instance;

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
}