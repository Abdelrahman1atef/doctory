import '../../../../../core/network/interfaces/api_result.dart';
import '../model/conversation_model.dart';
import '../model/message_model.dart';
import '../data_source/chat_remote_data_source.dart';

abstract class ChatRepo {
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
  Future<ApiResult<List<dynamic>>> searchUsers(String query);
}

class ChatRepoImpl implements ChatRepo {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepoImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<List<ConversationModel>>> getConversations({int pageNumber = 1, int pageSize = 10}) async {
    return await remoteDataSource.getConversations(pageNumber: pageNumber, pageSize: pageSize);
  }

  @override
  Future<ApiResult<String>> createConversation(String recipientId) async {
    return await remoteDataSource.createConversation(recipientId);
  }

  @override
  Future<ApiResult<ConversationModel>> getConversationDetail(String id) async {
    return await remoteDataSource.getConversationDetail(id);
  }

  @override
  Future<ApiResult<String>> deleteConversation(String id) async {
    return await remoteDataSource.deleteConversation(id);
  }

  @override
  Future<ApiResult<List<MessageModel>>> getMessages(String conversationId, {int pageNumber = 1, int pageSize = 50}) async {
    return await remoteDataSource.getMessages(conversationId, pageNumber: pageNumber, pageSize: pageSize);
  }

  @override
  Future<ApiResult<MessageModel>> sendMessage(String conversationId, String content, {String? replyToMessageId}) async {
    return await remoteDataSource.sendMessage(conversationId, content, replyToMessageId: replyToMessageId);
  }

  @override
  Future<ApiResult<String>> deleteMessage(String messageId) async {
    return await remoteDataSource.deleteMessage(messageId);
  }

  @override
  Future<ApiResult<bool>> setActiveConversation(String? conversationId) async {
    return await remoteDataSource.setActiveConversation(conversationId);
  }

  @override
  Future<ApiResult<bool>> sendTypingIndicator(String conversationId, bool isTyping) async {
    return await remoteDataSource.sendTypingIndicator(conversationId, isTyping);
  }

  @override
  Future<ApiResult<List<String>>> getTypingUsers(String conversationId) async {
    return await remoteDataSource.getTypingUsers(conversationId);
  }

  @override
  Future<ApiResult<List<String>>> getOnlineUsers() async {
    return await remoteDataSource.getOnlineUsers();
  }

  @override
  Future<ApiResult<List<dynamic>>> searchUsers(String query) async {
    return await remoteDataSource.searchUsers(query);
  }
}
