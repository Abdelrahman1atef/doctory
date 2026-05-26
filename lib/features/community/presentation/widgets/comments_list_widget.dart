import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/presentation/widgets/comment_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CommentsListWidget extends StatelessWidget {
  final List<CommentModel> comments;
  final bool isLoading;
  final bool isPagination;
  final ScrollController scrollController;
  final void Function(CommentModel) onLikeTapped;
  final void Function(CommentModel, String) onEditTapped;

  const CommentsListWidget({
    super.key,
    required this.comments,
    required this.isLoading,
    this.isPagination = false,
    required this.scrollController,
    required this.onLikeTapped,
    required this.onEditTapped,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && !isPagination && comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'no_comments_yet'.tr(),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length + (isLoading && isPagination ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= comments.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final comment = comments[index];
        return CommentItemWidget(
          comment: comment,
          onLikeTapped: () => onLikeTapped(comment),
          onEditTapped: (content) => onEditTapped(comment, content),
        );
      },
    );
  }
}
