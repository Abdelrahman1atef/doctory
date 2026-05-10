import '../../../../../core/network/interfaces/api_consumer.dart';
import '../model/conversation_model.dart';
import '../model/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ApiResult<List<ConversationModel>>> getConversations({int pageNumber = 1, int pageSize = 10});
  Future<ApiResult<String>> createConversation(String recipientId);
  Future<ApiResult<ConversationModel>> getConversationDetail(String id);
  Future<ApiResult<String>> deleteConversation(String id);
  Future<ApiResult<List<MessageModel>>> getMessages(String conversationId, {int pageNumber = 1, int pageSize = 50});
  Future<ApiResult<MessageModel>> sendMessage(String conversationId, String content, {String? replyToMessageId});
  Future<ApiResult<String>> deleteMessage(String messageId);
  Future<ApiResult<bool>> setActiveConversation(String? conversationId);
  Future<ApiResult<bool>> sendTypingIndicator(String conversationId, bool isTyping);
  Future<ApiResult<List<String>>> getTypingUsers(String conversationId);
  Future<ApiResult<List<String>>> getOnlineUsers();
  Future<ApiResult<List<dynamic>>> searchUsers(String query); // Assuming returns User models
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiConsumer apiConsumer;

  ChatRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ApiResult<List<ConversationModel>>> getConversations({int pageNumber = 1, int pageSize = 10}) async {
    return await apiConsumer.get<List<ConversationModel>>(
      path: 'conversations',
      queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
      parser: (json) {
        if (json.containsKey('data') && json['data'] is Map && json['data']['items'] is List) {
          return (json['data']['items'] as List)
              .map((i) => ConversationModel.fromJson(i))
              .toList();
        }
        return [];
      },
    );
  }

  @override
  Future<ApiResult<String>> createConversation(String recipientId) async {
    return await apiConsumer.post<String>(
      path: 'conversations/create',
      body: {'recipientId': recipientId},
      parser: (json) {
        if (json.containsKey('data')) {
          return json['data'].toString();
        }
        return '';
      },
    );
  }

  @override
  Future<ApiResult<ConversationModel>> getConversationDetail(String id) async {
    return await apiConsumer.get<ConversationModel>(
      path: 'conversations/$id',
      parser: (json) {
        if (json.containsKey('data')) {
          return ConversationModel.fromJson(json['data']);
        }
        return ConversationModel.fromJson(json);
      },
    );
  }

  @override
  Future<ApiResult<String>> deleteConversation(String id) async {
    return await apiConsumer.delete<String>(
      path: 'conversations/$id',
      parser: (json) {
        if (json.containsKey('message')) {
          return json['message'].toString();
        }
        return 'Success';
      },
    );
  }

  @override
  Future<ApiResult<List<MessageModel>>> getMessages(String conversationId, {int pageNumber = 1, int pageSize = 50}) async {
    return await apiConsumer.get<List<MessageModel>>(
      path: 'conversations/$conversationId/messages',
      queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
      parser: (json) {
        if (json.containsKey('data') && json['data'] is Map && json['data']['items'] is List) {
          return (json['data']['items'] as List)
              .map((i) => MessageModel.fromJson(i))
              .toList();
        }
        return [];
      },
    );
  }

  @override
  Future<ApiResult<MessageModel>> sendMessage(String conversationId, String content, {String? replyToMessageId}) async {
    return await apiConsumer.post<MessageModel>(
      path: 'conversations/$conversationId/messages',
      body: {
        'content': content,
        if (replyToMessageId != null) 'replyToMessageId': replyToMessageId,
      },
      parser: (json) {
        if (json.containsKey('data')) {
          return MessageModel.fromJson(json['data']);
        }
        return MessageModel.fromJson(json);
      },
    );
  }

  @override
  Future<ApiResult<String>> deleteMessage(String messageId) async {
    return await apiConsumer.delete<String>(
      path: 'conversations/messages/$messageId',
      parser: (json) {
        if (json.containsKey('message')) {
          return json['message'].toString();
        }
        return 'Success';
      },
    );
  }

  @override
  Future<ApiResult<bool>> setActiveConversation(String? conversationId) async {
    return await apiConsumer.post<bool>(
      path: 'realtime/active-conversation',
      body: {'conversationId': conversationId},
      parser: (_) => true,
    );
  }

  @override
  Future<ApiResult<bool>> sendTypingIndicator(String conversationId, bool isTyping) async {
    return await apiConsumer.post<bool>(
      path: 'realtime/typing',
      body: {
        'conversationId': conversationId,
        'isTyping': isTyping,
      },
      parser: (_) => true,
    );
  }

  @override
  Future<ApiResult<List<String>>> getTypingUsers(String conversationId) async {
    return await apiConsumer.get<List<String>>(
      path: 'realtime/typing/$conversationId',
      parser: (json) {
        if (json.containsKey('data') && json['data'] is List) {
          return (json['data'] as List).map((e) => e.toString()).toList();
        }
        return [];
      },
    );
  }

  @override
  Future<ApiResult<List<String>>> getOnlineUsers() async {
    return await apiConsumer.get<List<String>>(
      path: 'realtime/online-users',
      parser: (json) {
        if (json.containsKey('data') && json['data'] is List) {
          return (json['data'] as List).map((e) => e.toString()).toList();
        }
        return [];
      },
    );
  }

  @override
  Future<ApiResult<List<dynamic>>> searchUsers(String query) async {
    return await apiConsumer.get<List<dynamic>>(
      path: 'auth/users/search',
      queryParameters: {'query': query},
      parser: (json) {
        if (json.containsKey('data') && json['data'] is List) {
          return json['data'] as List;
        }
        return [];
      },
    );
  }
}
