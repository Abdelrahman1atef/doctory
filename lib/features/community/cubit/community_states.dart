import 'package:doctory/features/community/data/model/community_models.dart';

abstract class CommunityStates {}

class CommunityInitialState extends CommunityStates {}

class CommunityLoadingState extends CommunityStates {
  final bool isPagination;
  CommunityLoadingState({this.isPagination = false});
}

class CommunitySuccessState extends CommunityStates {
  final List<PostModel> posts;
  final bool hasReachedMax;
  CommunitySuccessState({required this.posts, required this.hasReachedMax});
}

class CommunityErrorState extends CommunityStates {
  final String message;
  CommunityErrorState(this.message);
}

// Actions States (Like, Create, Delete)
class CommunityActionLoadingState extends CommunityStates {}

class CommunityToggleLikeSuccessState extends CommunityStates {
  final String postId;
  final bool isLiked;
  CommunityToggleLikeSuccessState(this.postId, this.isLiked);
}

class CommunityToggleLikeErrorState extends CommunityStates {
  final String message;
  CommunityToggleLikeErrorState(this.message);
}

class CommunityCreatePostSuccessState extends CommunityStates {
  final String message;
  CommunityCreatePostSuccessState(this.message);
}

class CommunityCreatePostErrorState extends CommunityStates {
  final String message;
  CommunityCreatePostErrorState(this.message);
}
