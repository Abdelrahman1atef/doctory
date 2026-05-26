import 'package:doctory/features/community/data/model/community_models.dart';

abstract class PostDetailsStates {}

class PostDetailsInitialState extends PostDetailsStates {}

class PostDetailsLoadingState extends PostDetailsStates {
  final bool isPagination;
  PostDetailsLoadingState({this.isPagination = false});
}

class PostDetailsSuccessState extends PostDetailsStates {
  final PostModel post;
  final List<CommentModel> comments;
  final bool hasReachedMax;

  PostDetailsSuccessState({
    required this.post,
    required this.comments,
    required this.hasReachedMax,
  });
}

class PostDetailsErrorState extends PostDetailsStates {
  final String message;
  PostDetailsErrorState(this.message);
}

// Actions States
class PostDetailsActionLoadingState extends PostDetailsStates {}

class PostDetailsAddCommentSuccessState extends PostDetailsStates {
  final String message;
  PostDetailsAddCommentSuccessState(this.message);
}

class PostDetailsAddCommentErrorState extends PostDetailsStates {
  final String message;
  PostDetailsAddCommentErrorState(this.message);
}

class PostDetailsToggleLikeSuccessState extends PostDetailsStates {}

class PostDetailsToggleLikeErrorState extends PostDetailsStates {
  final String message;
  PostDetailsToggleLikeErrorState(this.message);
}

class PostReactionsLoadingState extends PostDetailsStates {}

class PostReactionsSuccessState extends PostDetailsStates {
  final List<ReactionModel> reactions;
  PostReactionsSuccessState(this.reactions);
}

class PostReactionsErrorState extends PostDetailsStates {
  final String message;
  PostReactionsErrorState(this.message);
}
