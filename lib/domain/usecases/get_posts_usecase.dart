import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPostsUsecase {
  final PostRepository postRepository;

  GetPostsUsecase(this.postRepository);

  Future<List<Post>> execute() async {
    return await postRepository.getPosts();
  }
}
