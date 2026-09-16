abstract final class PostGraphQLMutations {
  static const String createPost = r'''
    mutation CreatePost($title: String!, $body: String!) {
      createPost(input: { title: $title, body: $body }) {
        id
        title
        body
      }
    }
  ''';
}