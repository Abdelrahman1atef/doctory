import 'package:doctory/features/community/cubit/post_details_states.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/data/repo/community_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailsCubit extends Cubit<PostDetailsStates> {
  final CommunityRepo _communityRepo;

  PostDetailsCubit(this._communityRepo) : super(PostDetailsInitialState());

  late PostModel post;
  List<CommentModel> comments = [];
  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool _isLoading = false;

  void initPost(PostModel initialPost) {
    post = initialPost;
    getComments(refresh: true);
  }

  void getComments({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasReachedMax = false;
      comments.clear();
      emit(PostDetailsLoadingState(isPagination: false));
    } else {
      if (_hasReachedMax || _isLoading) return;
      emit(PostDetailsLoadingState(isPagination: true));
    }

    _isLoading = true;

    final result = await _communityRepo.getCommentsByPost(post.id, pageNumber: _currentPage);

    result.fold(
      onSuccess: (data) {
        if (data.items.isEmpty) {
          _hasReachedMax = true;
        } else {
          _currentPage++;
          comments.addAll(data.items);
          _hasReachedMax = !data.hasNextPage;
        }
        _isLoading = false;
        _emitSuccessState();
      },
      onFailure: (failure) {
        _isLoading = false;
        emit(PostDetailsErrorState(failure.message));
      },
    );
  }

  void addComment(String content) async {
    emit(PostDetailsActionLoadingState());

    final result = await _communityRepo.createComment(postId: post.id, content: content);

    result.fold(
      onSuccess: (id) {
        // Optimistically increment count
        post = post.copyWith(commentCount: post.commentCount + 1);
        emit(PostDetailsAddCommentSuccessState("comment_added_successfully"));
        getComments(refresh: true);
      },
      onFailure: (failure) {
        emit(PostDetailsAddCommentErrorState(failure.message));
        _emitSuccessState();
      },
    );
  }

  void togglePostLike({ReactionType type = ReactionType.like}) async {
    final isLiked = post.myReaction != ReactionType.none;
    final newReaction = (post.myReaction == type) ? ReactionType.none : type;
    final newIsLiked = newReaction != ReactionType.none;

    post = post.copyWith(
      myReaction: newReaction,
      reactionCount: (!isLiked && newIsLiked)
          ? post.reactionCount + 1
          : (isLiked && !newIsLiked)
          ? post.reactionCount - 1
          : post.reactionCount,
    );

    _emitSuccessState();

    final result = await _communityRepo.togglePostReaction(post.id, type: type.value);

    result.fold(
      onSuccess: (_) {
        emit(PostDetailsToggleLikeSuccessState());
      },
      onFailure: (failure) {
        post = post.copyWith(
          myReaction: isLiked ? type : ReactionType.none,
          reactionCount: isLiked ? post.reactionCount + 1 : post.reactionCount - 1,
        );
        _emitSuccessState();
        emit(PostDetailsToggleLikeErrorState(failure.message));
      },
    );
  }

  void toggleCommentLike(String commentId, {ReactionType type = ReactionType.like}) async {
    final commentIndex = comments.indexWhere((c) => c.id == commentId);
    if (commentIndex == -1) return;

    final comment = comments[commentIndex];
    final isLiked = comment.myReaction != ReactionType.none;
    final newReaction = (comment.myReaction == type) ? ReactionType.none : type;
    final newIsLiked = newReaction != ReactionType.none;

    comments[commentIndex] = comment.copyWith(
      myReaction: newReaction,
      reactionCount: (!isLiked && newIsLiked)
          ? comment.reactionCount + 1
          : (isLiked && !newIsLiked)
          ? comment.reactionCount - 1
          : comment.reactionCount,
    );

    _emitSuccessState();

    final result = await _communityRepo.toggleCommentReaction(commentId, type: type.value);

    result.fold(
      onSuccess: (_) {},
      onFailure: (failure) {
        comments[commentIndex] = comment;
        _emitSuccessState();
        emit(PostDetailsToggleLikeErrorState(failure.message));
      },
    );
  }

  Future<void> updateComment(String commentId, String content) async {
    emit(PostDetailsActionLoadingState());
    final result = await _communityRepo.updateComment(commentId: commentId, content: content);
    result.fold(
      onSuccess: (_) {
        final index = comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          comments[index] = comments[index].copyWith(content: content);
          _emitSuccessState();
        }
      },
      onFailure: (failure) {
        emit(PostDetailsErrorState(failure.message));
        _emitSuccessState();
      },
    );
  }

  Future<void> getPostReactions(String postId, {int page = 1}) async {
    emit(PostReactionsLoadingState());
    final result = await _communityRepo.getPostReactions(postId, pageNumber: page);
    result.fold(
      onSuccess: (data) => emit(PostReactionsSuccessState(data.items)),
      onFailure: (failure) => emit(PostReactionsErrorState(failure.message)),
    );
  }

  void _emitSuccessState() {
    emit(
      PostDetailsSuccessState(
        post: post,
        comments: List.from(comments),
        hasReachedMax: _hasReachedMax,
      ),
    );
  }
}
