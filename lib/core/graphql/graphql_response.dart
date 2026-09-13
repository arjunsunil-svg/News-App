class GraphQLResponse {
  const GraphQLResponse({
    required this.data,
    this.errors,
  });

  final Map<String, dynamic> data;
  final List<dynamic>? errors;
}