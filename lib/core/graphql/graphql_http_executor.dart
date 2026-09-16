import 'dart:convert';

import 'package:http/http.dart' as http;

import 'graphql_executor.dart';

class GraphQLHttpExecutor implements GraphQLExecutor {
  const GraphQLHttpExecutor(this._endpoint);

  final String _endpoint;

  @override
  Future<Map<String, dynamic>> execute(
      String document,
      Map<String, dynamic> variables,
      ) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': document,
        'variables': variables,
      }),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (decoded['errors'] != null) {
      final errors = decoded['errors'] as List<dynamic>;
      final message = errors
          .map((error) => (error as Map<String, dynamic>)['message'])
          .join(', ');
      throw Exception(message);
    }

    return decoded['data'] as Map<String, dynamic>;
  }
}