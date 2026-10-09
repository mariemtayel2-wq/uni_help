import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/chat_screen/domain/entities/chat_summary_entity.dart';
import 'package:uni_help/features/chat_screen/presentation/view/screen/chat_screen.dart';
import 'package:uni_help/features/chat_screen/presentation/view/screen/chat_shimmer.dart';
import 'package:uni_help/features/chat_screen/presentation/view_model/chat_list_cubit.dart';
import 'package:uni_help/features/chat_screen/presentation/view_model/chat_list_state_cubit.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ChatsListCubit>()..watchChats(),
      child: const _ChatsListView(),
    );
  }
}

class _ChatsListView extends StatelessWidget {
  const _ChatsListView();

  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_new, size: 18.sp, color: AppColors.largeTextColor),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Messages',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ChatsListCubit, ChatsListState>(
          builder: (context, state) {
            if (state is ChatsListLoading || state is ChatsListInitial) {
              return  ChatShimmer();
                        }

            if (state is ChatsListError) {
              return Center(child: Text(state.message, textAlign: TextAlign.center));
            }

            final loaded = state as ChatsListLoaded;

            if (loaded.chats.isEmpty) {
              return Center(
                child: Text(
                  'No conversations yet',
                  style: TextStyle(fontSize: 14.sp, color: AppColors.mediumTextColor),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              itemCount: loaded.chats.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                return _ChatTile(chat: loaded.chats[index], currentUserId: _currentUserId);
              },
            );
          },
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat, required this.currentUserId});

  final ChatSummaryEntity chat;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final otherUserId = chat.otherUserId(currentUserId);

    return FutureBuilder<String>(
      future: context.read<ChatsListCubit>().getUserName(otherUserId),
      builder: (context, snapshot) {
        final loadedName = snapshot.data?.trim() ?? '';
        final name = loadedName.isEmpty ? 'User' : loadedName;
        final initials = _initialsOf(name);

        return InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  requestId: chat.requestId,
                  requesterId: chat.requesterId,
                  applicantId: chat.applicantId,
                  otherUserId: otherUserId,
                  otherUserName: name,
                  otherUserInitials: initials,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.primaryColor,
                  child: Text(
                    initials,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        chat.lastMessage.isEmpty ? 'No messages yet' : chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.sp, color: AppColors.mediumTextColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  _formatTime(chat.lastMessageAt),
                  style: TextStyle(fontSize: 10.sp, color: AppColors.mediumTextColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return (parts.first[0] + parts[1][0]).toUpperCase();
}

// النهارده بنعرض الساعة، وغير كده بنعرض التاريخ.
String _formatTime(DateTime time) {
  final now = DateTime.now();
  final isToday = time.year == now.year && time.month == now.month && time.day == now.day;

  if (isToday) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  return '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}';
}