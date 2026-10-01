
import 'package:uni_help/features/chat_screen/domain/entities/chat_summary_entity.dart';

abstract class ChatsListState {
  const ChatsListState();
}

class ChatsListInitial extends ChatsListState {
  const ChatsListInitial();
}

class ChatsListLoading extends ChatsListState {
  const ChatsListLoading();
}

class ChatsListLoaded extends ChatsListState {
  const ChatsListLoaded({required this.chats});

  final List<ChatSummaryEntity> chats;
}

class ChatsListError extends ChatsListState {
  const ChatsListError(this.message);

  final String message;
}