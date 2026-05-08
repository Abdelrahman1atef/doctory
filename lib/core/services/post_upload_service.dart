import 'dart:async';
import 'package:doctory/features/create_post/data/model/selected_media_model.dart';
import 'package:doctory/features/create_post/data/repo/create_post_repo.dart';

enum UploadStatus { uploading, success, failed }

class PostUploadTask {
  final String id;
  final String content;
  final List<SelectedMediaModel> media;
  UploadStatus status;
  String? errorMessage;

  PostUploadTask({
    required this.id,
    required this.content,
    required this.media,
    this.status = UploadStatus.uploading,
    this.errorMessage,
  });
}

class PostUploadService {
  final CreatePostRepo _repo;
  PostUploadService({required CreatePostRepo repo}) : _repo = repo;

  final Map<String, PostUploadTask> _tasks = {};
  final _tasksController = StreamController<List<PostUploadTask>>.broadcast();

  Stream<List<PostUploadTask>> get tasksStream => _tasksController.stream;

  void _emit() {
    _tasksController.add(_tasks.values.toList());
  }

  void submitPost({
    required String content,
    required List<SelectedMediaModel> media,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final task = PostUploadTask(id: id, content: content, media: media);
    _tasks[id] = task;
    _emit();
    _processTask(task);
  }

  Future<void> _processTask(PostUploadTask task) async {
    task.status = UploadStatus.uploading;
    _emit();

    // Wait for ongoing compressions to finish
    while (task.media.any((m) => m.isCompressing)) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    final result = await _repo.createPostWithMedia(
      content: task.content,
      media: task.media,
    );
    result.fold(
      onSuccess: (_) {
        task.status = UploadStatus.success;
        _emit();
        // Remove after a short delay so UI can show success message then hide
        Future.delayed(const Duration(seconds: 3), () {
          _tasks.remove(task.id);
          _emit();
        });
      },
      onFailure: (failure) {
        task.status = UploadStatus.failed;
        task.errorMessage = failure.message;
        _emit();
      },
    );
  }

  void retryTask(String id) {
    if (_tasks.containsKey(id)) {
      _processTask(_tasks[id]!);
    }
  }

  void dismissTask(String id) {
    _tasks.remove(id);
    _emit();
  }
}
