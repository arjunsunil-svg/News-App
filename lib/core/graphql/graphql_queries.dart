abstract final class GraphQLQueries {
  static const String getNews = r'''
    query GetNews {
      articles {
        id
        title
        description
        content
        url
        image
        publishedAt
        lang
        source {
          id
          name
          url
          country
        }
      }    
    }
  ''';
}