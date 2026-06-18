import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/presentation/widgets/reaction_button_content_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReactionsBottomSheet extends StatelessWidget {
  final Future<void> Function(int) fetchReactions;
  final List<ReactionModel> reactions;
  final bool isLoading;

  const ReactionsBottomSheet({
    super.key,
    required this.fetchReactions,
    required this.reactions,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          Text('reactions'.tr(),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: reactions.length,
                    itemBuilder: (context, index) {
                      final reaction = reactions[index];
                      return ListTile(
                        title: Text(reaction.userName ?? 'user'.tr()),
                        trailing: Text(
                          ReactionEmojiHelper.getReactionEmoji(reaction.type),
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
