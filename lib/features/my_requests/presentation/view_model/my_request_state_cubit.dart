import 'package:uni_help/core/entities/request_entity.dart';

abstract class MyRequestsStateCubit {}
class MyRequestsStateInitial extends MyRequestsStateCubit {}
class MyRequestsStateLoading extends MyRequestsStateCubit {}
class MyRequestsStateLoaded extends MyRequestsStateCubit {
  final List<RequestEntity> requests;
  MyRequestsStateLoaded(this.requests);
}
class MyRequestsStateError extends MyRequestsStateCubit {
  final String message;
  MyRequestsStateError(this.message);
}