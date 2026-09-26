import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/notification_screen/domain/entities/notification_entity.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification, required this.onTap});

  final NotificationEntity notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: notification.isRead ? null : AppColors.primaryColor.withOpacity(0.06),
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        backgroundImage: notification.senderAvatarUrl != null
            ? NetworkImage(notification.senderAvatarUrl!)
            : null,
        child: notification.senderAvatarUrl == null
            ? Text(
                notification.senderName.isNotEmpty ? notification.senderName[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          color: AppColors.largeTextColor,
        ),
      ),
      subtitle: Text(
        notification.body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12.sp, color: AppColors.mediumTextColor),
      ),
      trailing: Text(
        timeago.format(notification.createdAt),
        style: TextStyle(fontSize: 11.sp, color: AppColors.mediumTextColor),
      ),
    );
  }
}