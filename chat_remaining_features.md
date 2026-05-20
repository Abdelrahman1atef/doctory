# Implementation Plan — Remaining Chat Features

This plan outlines the steps to complete the missing functionalities in the Chat feature, ensuring full alignment with the `REALTIME_FLUTTER_GUIDE.md` and project architecture.

## 1. Objective
Complete the Chat feature by adding:
- Message Delivered status handling.
- Explicit cleanup on screen exit.
- UI for message/conversation deletion.
- Reply mechanism (Swipe/UI).
- Media support (Images/Files).
- Message Reactions.

## 2. Key Files & Context
- **Realtime Logic**: `lib/core/services/chat/chat_realtime_service.dart`
- **Business Logic**: `lib/features/chat/cubit/chat_room/chat_room_cubit.dart`
- **Views**: `lib/features/chat/presentation/views/chat_room_view.dart`
- **Widgets**: `lib/features/chat/presentation/widgets/chat_message_widget.dart`

---

## 3. Implementation Steps

### Milestone 1: Refinement & State Completion
1.  **Delivered Status**:
    - Update `PusherConfig` to include `messages-delivered` event.
    - Add `onMessagesDelivered` stream to `ChatRealtimeService`.
    - Update `ChatRoomCubit` to listen to this stream and update message status to 'Delivered' (double gray ticks).
2.  **Reliable Cleanup**:
    - Wrap `ChatRoomView` body in a `PopScope` (or `WillPopScope`) to explicitly call `cubit.leaveConversation()` when the user presses back.

### Milestone 2: UI Interactions (Deletion & Replies)
1.  **Message Deletion**:
    - Add a `LongPress` menu to `ChatMessageWidget`.
    - Implement `deleteMessage` in `ChatRoomCubit` (calling repo).
    - Optimistically remove message from state.
2.  **Conversation Deletion**:
    - Add "Dismissible" or LongPress delete to `ConversationItemWidget`.
3.  **Reply Mechanism**:
    - Implement a "Swipe to Reply" gesture on `ChatMessageWidget`.
    - Add `replyingTo` state to `ChatRoomCubit`.
    - Show a small preview of the replied message above the text input field in `ChatRoomView`.

### Milestone 3: Media & Rich Content
1.  **File/Image Picking**:
    - Add an "Attachment" icon to the message input field.
    - Integrate `image_picker` or `file_picker`.
2.  **Upload Logic**:
    - Update `ChatRoomCubit.sendMessage` to handle `XFile` or `File`.
    - Use `isFormData: true` in `ChatRemoteDataSource`.
3.  **Rendering**:
    - Create `ChatImageWidget` and `ChatFileWidget` to display media inside messages.

### Milestone 4: Polish (Reactions)
1.  **Reaction Logic**:
    - Add `toggleReaction` to `ChatRoomCubit`.
    - Show an emoji picker on long-press.
2.  **Real-time Reactions**:
    - Add listener in `ChatRoomCubit` for incoming reaction events (if supported by backend).

---

## 4. Verification & Testing
- **Manual Test**: Send a message from User A to User B (offline). Log in User B and verify User A's ticks turn from single to double gray.
- **Manual Test**: Open a chat, go back, and verify the unread counter on the list screen is 0 for that chat.
- **Manual Test**: Delete a message and verify it disappears for both users (via Pusher event if applicable).
- **Unit Test**: Verify `ChatRoomCubit` emits correct states when `onMessagesDelivered` event is received.
