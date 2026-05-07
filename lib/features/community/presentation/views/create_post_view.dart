import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/community/cubit/community_cubit.dart';
import 'package:doctory/features/community/presentation/sections/create_post_app_bar_section.dart';
import 'package:doctory/features/community/presentation/sections/create_post_body_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CommunityCubit>(),
      child: Scaffold(
        appBar: CreatePostAppBarSection(contentController: _contentController),
        body: CreatePostBodySection(contentController: _contentController),
      ),
    );
  }
}
