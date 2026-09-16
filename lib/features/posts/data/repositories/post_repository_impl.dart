import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  const PostRepositoryImpl(this._remoteDataSource);

  final PostRemoteDataSource _remoteDataSource;

  @override
  Future<PostEntity> createPost({
    required String title,
    required String body,
  }) {
    return _remoteDataSource.createPost(title: title, body: body);
  }
}