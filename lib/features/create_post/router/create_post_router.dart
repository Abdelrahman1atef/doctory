import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/create_post/cubit/gallery_picker_cubit.dart';
import 'package:doctory/features/create_post/presentation/views/create_post_view.dart';
import 'package:doctory/features/create_post/presentation/views/gallery_picker_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreatePostRouter {
  static GoRoute get route => GoRoute(
    path: AppRoutes.createPost,
    builder: (context, state) => const CreatePostView(),
    routes: [
      GoRoute(
        path: 'galleryPicker',
        builder: (context, state) => BlocProvider(
          create: (context) => GalleryPickerCubit(),
          child: const GalleryPickerView(),
        ),
      ),
    ],
  );
}
