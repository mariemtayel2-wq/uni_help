import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/chat_screen/domain/entities/message_entity.dart';
import 'package:uni_help/features/chat_screen/domain/use_case/create_chat_use_case.dart';
import 'package:uni_help/features/chat_screen/domain/use_case/send_message_use_case.dart';
import 'package:uni_help/features/chat_screen/domain/use_case/watch_message_use_case.dart';
import 'package:uni_help/features/chat_screen/presentation/view_model/chat_state_cubit.dart';


@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._getOrCreateChatUseCase, this._watchMessagesUseCase, this._sendMessageUseCase)
    : super(const ChatInitial());

  final GetOrCreateChatUseCase _getOrCreateChatUseCase;
  final WatchMessagesUseCase _watchMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  Future<void> openChat({
    required String requestId,
    required String requesterId,
    required String applicantId,
  }) async {
    emit(const ChatLoading());

    try {
      final chatId = await _getOrCreateChatUseCase(
        requestId: requestId,
        requesterId: requesterId,
        applicantId: applicantId,
      );

      await _messagesSubscription?.cancel();

      _messagesSubscription = _watchMessagesUseCase(chatId).listen(
        (messages) {
          final current = state;
          if (current is ChatLoaded) {
            emit(current.copyWith(messages: messages));
          } else {
            emit(ChatLoaded(chatId: chatId, messages: messages));
          }
        },
        onError: (Object e) => emit(ChatError(e.toString().replaceFirst('Exception: ', ''))),
      );
    } catch (e) {
      emit(ChatError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> sendMessage(String text) async {
    final current = state;
    if (current is! ChatLoaded || text.trim().isEmpty) return;

    try {
      await _sendMessageUseCase(chatId: current.chatId, text: text.trim());
    } catch (e) {
      emit(ChatError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}