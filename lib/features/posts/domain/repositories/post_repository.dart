import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<PostEntity> createPost({
    required String title,
    required String body,
  });
}