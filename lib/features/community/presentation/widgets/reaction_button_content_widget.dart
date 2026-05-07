import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReactionButtonContentWidget extends StatelessWidget {
  final ReactionType type;

  const ReactionButtonContentWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final color = type != ReactionType.none ? _getReactionColor(type) : AppColors.textSecondary;
    final icon = _getReactionIcon(type);
    final label = _getReactionLabel(type).tr();

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          8.pw,
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getReactionIcon(ReactionType type) {
    switch (type) {
      case ReactionType.like:
        return Icons.thumb_up;
      case ReactionType.love:
        return Icons.favorite;
      case ReactionType.haha:
        return Icons.sentiment_very_satisfied;
      case ReactionType.wow:
        return Icons.sentiment_neutral;
      case ReactionType.sad:
        return Icons.sentiment_dissatisfied;
      case ReactionType.angry:
        return Icons.mood_bad;
      case ReactionType.none:
        return Icons.thumb_up_alt_outlined;
    }
  }

  Color _getReactionColor(ReactionType type) {
    switch (type) {
      case ReactionType.like:
        return AppColors.stitchPrimary;
      case ReactionType.love:
        return Colors.red;
      case ReactionType.haha:
      case ReactionType.wow:
      case ReactionType.sad:
        return Colors.orange;
      case ReactionType.angry:
        return Colors.deepOrange;
      case ReactionType.none:
        return AppColors.textSecondary;
    }
  }

  String _getReactionLabel(ReactionType type) {
    switch (type) {
      case ReactionType.like:
        return 'like';
      case ReactionType.love:
        return 'love';
      case ReactionType.haha:
        return 'haha';
      case ReactionType.wow:
        return 'wow';
      case ReactionType.sad:
        return 'sad';
      case ReactionType.angry:
        return 'angry';
      case ReactionType.none:
        return 'like';
    }
  }
}

class ReactionEmojiHelper {
  static String getReactionEmoji(ReactionType type) {
    switch (type) {
      case ReactionType.like:
        return '👍';
      case ReactionType.love:
        return '❤️';
      case ReactionType.haha:
        return '😂';
      case ReactionType.wow:
        return '😮';
      case ReactionType.sad:
        return '😢';
      case ReactionType.angry:
        return '😡';
      case ReactionType.none:
        return '';
    }
  }
}
