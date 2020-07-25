import 'package:bloc/bloc.dart';

import '../model/post.dart';

class PostEvent {}

abstract class PostState {}

class PostUnintialized extends PostState {}

class PostLoaded extends PostState {
  List<Post> posts;
  bool hasReachedMax;

  PostLoaded({this.posts, this.hasReachedMax});

  PostLoaded copyWith({List<Post> posts, bool hasReachedMax}) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc(PostState initialState) : super(PostUnintialized());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    List<Post> posts;
    if (state is PostUnintialized) {
      posts = await Post.connectToApi(0, 10);
      yield PostLoaded(posts: posts, hasReachedMax: false);
    } else {
      PostLoaded postLoaded = state as PostLoaded;
      posts = await Post.connectToApi(postLoaded.posts.length, 10);

      yield (posts.isEmpty)
          ? postLoaded.copyWith(hasReachedMax: true)
          : PostLoaded(
              posts: postLoaded.posts + posts,
              hasReachedMax: false,
            );
    }
  }
}
