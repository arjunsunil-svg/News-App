abstract class GraphQLExecutor {
  Future<Map<String, dynamic>> execute(
      String document,
      Map<String, dynamic> variables,
      );
}