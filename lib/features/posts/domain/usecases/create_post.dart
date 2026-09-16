import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class CreatePost {
  const CreatePost(this._repository);

  final PostRepository _repository;

  Future<PostEntity> call({
    required String title,
    required String body,
  }) {
    return _repository.createPost(title: title, body: body);
  }
}