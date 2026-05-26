import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CommentItemWidget extends StatefulWidget {
  final CommentModel comment;
  final VoidCallback onLikeTapped;
  final Function(String) onEditTapped;

  const CommentItemWidget({
    super.key,
    required this.comment,
    required this.onLikeTapped,
    required this.onEditTapped,
  });

  @override
  State<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {
  bool _isEditing = false;
  final TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editController.text = widget.comment.content;
  }

  @override
  Widget build(BuildContext context) {
    final isMe = widget.comment.authorId == UserSession.userId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: widget.comment.authorImage != null &&
                    widget.comment.authorImage!.isNotEmpty
                ? NetworkImage(widget.comment.authorImage!.toImageUrl)
                : null,
            backgroundColor: AppColors.grey100,
            child: widget.comment.authorImage == null ||
                    widget.comment.authorImage!.isEmpty
                ? const Icon(Icons.person, color: Colors.grey, size: 20)
                : null,
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.comment.authorName ?? 'user'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          if (isMe)
                            if (_isEditing)
                              IconButton(
                                icon: const Icon(Icons.check, size: 16),
                                onPressed: () {
                                  widget.onEditTapped(_editController.text);
                                  setState(() => _isEditing = false);
                                },
                              )
                            else
                              IconButton(
                                icon: const Icon(Icons.edit, size: 16),
                                onPressed: () =>
                                    setState(() => _isEditing = true),
                              ),
                        ],
                      ),
                      4.ph,
                      _isEditing
                          ? TextField(controller: _editController)
                          : Text(
                              widget.comment.content,
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                    ],
                  ),
                ),
                4.ph,
                Row(
                  children: [
                    Text(
                      _formatDate(widget.comment.createdAt),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    16.pw,
                    InkWell(
                      onTap: widget.onLikeTapped,
                      child: Text(
                        'like'.tr(),
                        style: TextStyle(
                          fontWeight: widget.comment.myReaction != ReactionType.none
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: widget.comment.myReaction != ReactionType.none
                              ? AppColors.stitchPrimary
                              : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (widget.comment.reactionCount > 0) ...[
                      8.pw,
                      const Icon(
                        Icons.thumb_up,
                        size: 12,
                        color: AppColors.stitchPrimary,
                      ),
                      4.pw,
                      Text(
                        '${widget.comment.reactionCount}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM, hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
