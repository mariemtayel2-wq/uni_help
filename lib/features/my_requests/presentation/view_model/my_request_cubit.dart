import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/features/my_requests/domain/use_case/delete_request_use_case.dart';
import 'package:uni_help/features/my_requests/domain/use_case/mark_request_as_read_use_case.dart';
import 'package:uni_help/features/my_requests/domain/use_case/watch_request_use_case.dart';
import 'package:uni_help/features/my_requests/presentation/view_model/my_request_state_cubit.dart';


@injectable
class MyRequestsCubit extends Cubit<MyRequestsStateCubit> {
  MyRequestsCubit(this._watchMyRequests, this._deleteRequest, this._markCompleted)
      : super(MyRequestsStateInitial());

  final WatchMyRequestsUseCase _watchMyRequests;
  final DeleteRequestUseCase _deleteRequest;
  final MarkRequestCompletedUseCase _markCompleted;
  StreamSubscription<List<RequestEntity>>? _sub;

  void listen(String uid) {
    emit(MyRequestsStateLoading());
    _sub?.cancel();
    _sub = _watchMyRequests(uid).listen(
      (list) => emit(MyRequestsStateLoaded(list)),
      onError: (e) => emit(MyRequestsStateError(e.toString())),
    );
  }

  Future<String?> deleteRequest(RequestEntity request) async {
    try {
      await _deleteRequest(request);
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> markAsCompleted(String requestId) => _markCompleted(requestId);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}