import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/my_requests/presentation/view/widget/my_request_card.dart';
import 'package:uni_help/features/my_requests/presentation/view_model/my_request_cubit.dart';
import 'package:uni_help/features/my_requests/presentation/view_model/my_request_state_cubit.dart';
import 'package:uni_help/features/rating/presentation/view/screens/rating_screen.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return BlocProvider(
      create: (_) => serviceLocator<MyRequestsCubit>()..listen(uid),
      child: const _MyRequestsView(),
    );
  }
}

class _MyRequestsView extends StatelessWidget {
  const _MyRequestsView();

  Future<void> _confirmDelete(BuildContext context, RequestEntity request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Delete Request'),
        content: const Text('Are you sure? This will permanently remove this request.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final error = await context.read<MyRequestsCubit>().deleteRequest(request);
    if (!context.mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _handleMarkDone(BuildContext context, RequestEntity request) async {
    if (request.id == null || request.helperId == null) return;
    await context.read<MyRequestsCubit>().markAsCompleted(request.id!);
    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RateHelperScreen(
          targetUserId: request.helperId!,
          targetUserName: request.helperName ?? 'Helper',
          requestId: request.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('My Requests')),
      body: BlocBuilder<MyRequestsCubit, MyRequestsStateCubit>(
        builder: (context, state) {
          if (state is MyRequestsStateLoading || state is MyRequestsStateInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MyRequestsStateError) {
            return Center(child: Text(state.message));
          }
          final requests = (state as MyRequestsStateLoaded).requests;
          if (requests.isEmpty) {
            return Center(child: Text("You haven't created any requests yet", style: TextStyle(color: AppColors.mediumTextColor)));
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: requests.length,
            itemBuilder: (_, i) => MyRequestCard(
              request: requests[i],
              onDelete: () => _confirmDelete(context, requests[i]),
              onMarkDone: () => _handleMarkDone(context, requests[i]),
            ),
          );
        },
      ),
    );
  }
}