import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/chat_screen/domain/entities/chat_summary_entity.dart';
import 'package:uni_help/features/chat_screen/domain/use_case/get_user_name_use_case.dart';
import 'package:uni_help/features/chat_screen/domain/use_case/watch_my_chats_use_case.dart';
import 'package:uni_help/features/chat_screen/presentation/view_model/chat_list_state_cubit.dart';


@injectable
class ChatsListCubit extends Cubit<ChatsListState> {
  ChatsListCubit(this._watchMyChatsUseCase, this._getUserNameUseCase) : super(const ChatsListInitial());

  final WatchMyChatsUseCase _watchMyChatsUseCase;
  final GetUserNameUseCase _getUserNameUseCase;

  StreamSubscription<List<ChatSummaryEntity>>? _chatsSubscription;

  // كاش للأسامي عشان ما نعملش قراءة من Firestore مع كل rebuild.
  final Map<String, Future<String>> _userNames = {};

  Future<void> watchChats() async {
    emit(const ChatsListLoading());

    try {
      await _chatsSubscription?.cancel();

      _chatsSubscription = _watchMyChatsUseCase().listen(
        (chats) => emit(ChatsListLoaded(chats: chats)),
        onError: (Object e) => emit(ChatsListError(e.toString().replaceFirst('Exception: ', ''))),
      );
    } catch (e) {
      emit(ChatsListError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<String> getUserName(String userId) =>
      _userNames.putIfAbsent(userId, () => _getUserNameUseCase(userId));

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }
}