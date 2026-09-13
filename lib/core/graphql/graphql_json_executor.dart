import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'graphql_queries.dart';

class GraphQLJsonExecutor {
  GraphQLJsonExecutor._();

  static final GraphQLJsonExecutor instance =  GraphQLJsonExecutor._();

  List<Map<String, dynamic>>? _articles;

  Future<void> _ensureLoaded() async {
    if (_articles != null) {
      return;
    }

    final raw = await rootBundle.loadString(
      'assets/data/news.json',
    );

    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    final articles = decoded['articles'] as List<dynamic>;

    _articles = articles
        .map(
          (article) =>
      Map<String, dynamic>.from(
        article as Map<dynamic, dynamic>,
      ),
    )
        .toList();
  }

  Future<Map<String, dynamic>> execute(
      String document,
      Map<String, dynamic> variables,
      ) async {
    await _ensureLoaded();

    if (document == GraphQLQueries.getNews) {
      return {
        'articles': _articles,
      };
    }

    throw UnsupportedError(
      'Unknown GraphQL document: $document',
    );
  }
}