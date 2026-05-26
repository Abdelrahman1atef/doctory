import 'package:doctory/features/community/cubit/community_states.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/data/repo/community_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityCubit extends Cubit<CommunityStates> {
  final CommunityRepo _communityRepo;

  CommunityCubit(this._communityRepo) : super(CommunityInitialState());

  List<PostModel> posts = [];
  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool _isLoading = false;

  Future<void> getPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasReachedMax = false;
      posts.clear();
    }

    if (_hasReachedMax || _isLoading) return;

    _isLoading = true;
    emit(CommunityLoadingState(isPagination: _currentPage > 1));

    final result = await _communityRepo.getPosts(pageNumber: _currentPage);

    result.fold(
      onSuccess: (data) {
        if (data.items.isEmpty) {
          _hasReachedMax = true;
        } else {
          _currentPage++;
          posts.addAll(data.items);
          _hasReachedMax = !data.hasNextPage;
        }
        _isLoading = false;
        emit(
          CommunitySuccessState(
            posts: List.from(posts),
            hasReachedMax: _hasReachedMax,
          ),
        );
      },
      onFailure: (failure) {
        _isLoading = false;
        emit(CommunityErrorState(failure.message));
      },
    );
  }

  void toggleLike(
    String postId, {
    ReactionType type = ReactionType.like,
  }) async {
    // Optimistic update
    final postIndex = posts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;

    final post = posts[postIndex];
    final isLiked = post.myReaction != ReactionType.none;

    // If the same reaction is clicked again, we "unlike" it
    final newReaction = (post.myReaction == type) ? ReactionType.none : type;
    final newIsLiked = newReaction != ReactionType.none;

    // Update local state
    posts[postIndex] = post.copyWith(
      myReaction: newReaction,
      reactionCount: (!isLiked && newIsLiked)
          ? post.reactionCount + 1
          : (isLiked && !newIsLiked)
          ? post.reactionCount - 1
          : post.reactionCount,
    );

    emit(
      CommunitySuccessState(
        posts: List.from(posts),
        hasReachedMax: _hasReachedMax,
      ),
    );

    final result = await _communityRepo.togglePostReaction(
      postId,
      type: type.value,
    );

    result.fold(
      onSuccess: (_) {
        emit(CommunityToggleLikeSuccessState(postId, newIsLiked));
      },
      onFailure: (failure) {
        // Revert on failure
        posts[postIndex] = post;
        emit(
          CommunitySuccessState(
            posts: List.from(posts),
            hasReachedMax: _hasReachedMax,
          ),
        );
        emit(CommunityToggleLikeErrorState(failure.message));
      },
    );
  }

  Future<void> getPostReactions(String postId, {int page = 1}) async {
    emit(CommunityReactionsLoadingState());
    final result =
        await _communityRepo.getPostReactions(postId, pageNumber: page);
    result.fold(
      onSuccess: (data) => emit(CommunityReactionsSuccessState(data.items)),
      onFailure: (failure) => emit(CommunityReactionsErrorState(failure.message)),
    );
  }
}
