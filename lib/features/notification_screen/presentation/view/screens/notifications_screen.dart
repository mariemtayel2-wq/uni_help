import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/chat_screen/presentation/view/screen/chat_screen.dart';
import 'package:uni_help/features/notification_screen/domain/entities/notification_entity.dart';
import 'package:uni_help/features/notification_screen/presentation/view/notification_shimmer.dart';
import 'package:uni_help/features/notification_screen/presentation/view/widget/notification_tile.dart';
import 'package:uni_help/features/notification_screen/presentation/view_model/notification_cubit.dart';
import 'package:uni_help/features/notification_screen/presentation/view_model/notification_state_cubit.dart';
import 'package:uni_help/features/request_detail_screen/request_details_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  void _handleTap(BuildContext context, NotificationEntity n) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await context.read<NotificationsCubit>().onNotificationTapped(uid, n);
    if (!context.mounted) return;

    if (n.chatId != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(
        requestId: n.chatId!,
        otherUserId: n.senderId,
        otherUserName: n.senderName,
        otherUserInitials: n.senderInitials,
      )
      ));
    } else if (n.request != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RequestDetailsScreen(request: n.request!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationsCubit>().markAllAsRead(uid),
            child: Text('Mark all as read', style: TextStyle(fontSize: 12.sp, color: AppColors.primaryColor)),
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsStateCubit>(
        builder: (context, state) {
          if (state is NotificationsStateLoading || state is NotificationsStateInitial) {
            return NotificationShimmer();
          }
          if (state is NotificationsStateError) {
            return Center(child: Text(state.message));
          }
          final list = (state as NotificationsStateLoaded).notifications;
          if (list.isEmpty) {
            return Center(
              child: Text('No notifications yet', style: TextStyle(color: AppColors.mediumTextColor)),
            );
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) => NotificationTile(
              notification: list[i],
              onTap: () => _handleTap(context, list[i]),
            ),
          );
        },
      ),
    );
  }
}