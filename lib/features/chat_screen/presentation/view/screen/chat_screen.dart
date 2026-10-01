import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/services/presence_service.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/chat_screen/domain/entities/message_entity.dart';
import 'package:uni_help/features/chat_screen/presentation/view/screen/chat_shimmer.dart';
import 'package:uni_help/features/chat_screen/presentation/view_model/chat_cubit.dart';
import 'package:uni_help/features/chat_screen/presentation/view_model/chat_state_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    required this.requestId,
    required this.applicantId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserInitials,
    super.key,
  });

  final String requestId;

  /// المتقدم على الطلب: لو أنا المتقدم يبقى myUid، ولو أنا صاحب الطلب يبقى otherUserId.
  final String applicantId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserInitials;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
        // لو أنا المتقدم يبقى صاحب الطلب هو الطرف التاني، والعكس صحيح.
        final requesterId = applicantId == myUid ? otherUserId : myUid;
        return serviceLocator<ChatCubit>()
          ..openChat(requestId: requestId, requesterId: requesterId, applicantId: applicantId);
      },
      child: _ChatView(
        otherUserId: otherUserId,
        otherUserName: otherUserName,
        otherUserInitials: otherUserInitials,
      ),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView({
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserInitials,
  });

  final String otherUserId;
  final String otherUserName;
  final String otherUserInitials;

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  // بنعمل الـ stream مرة واحدة هنا عشان ما يتعملش subscribe جديد مع كل rebuild.
  late final Stream<bool> _onlineStream = serviceLocator<PresenceService>().watchOnline(widget.otherUserId);

  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    if (_messageController.text.trim().isEmpty) return;
    context.read<ChatCubit>().sendMessage(_messageController.text);
    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18.sp, color: AppColors.largeTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.primaryColor,
              child: Text(
                widget.otherUserInitials,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUserName,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
                ),
                // حالة الـ Online الحقيقية من Realtime Database.
                StreamBuilder<bool>(
                  stream: _onlineStream,
                  initialData: false,
                  builder: (context, snapshot) {
                    final isOnline = snapshot.data ?? false;
                    final color = isOnline ? Colors.green : Colors.grey;

                    return Row(
                      children: [
                        Container(
                          width: 7.w,
                          height: 7.w,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        ),
                        SizedBox(width: 4.w),
                        Text(isOnline ? 'Online' : 'Offline', style: TextStyle(fontSize: 11.sp, color: color)),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert, color: AppColors.largeTextColor), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading || state is ChatInitial) {
                  return const ChatShimmer();
                }

                if (state is ChatError) {
                  return Center(child: Text(state.message, textAlign: TextAlign.center));
                }

                final loaded = state as ChatLoaded;

                return ListView.builder(
                  controller: _scrollController,
                  // مساحة تحت كفاية عشان آخر رسالة متتغطاش بالـ input العايم.
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 90.h),
                  itemCount: loaded.messages.length,
                  itemBuilder: (context, index) {
                    final message = loaded.messages[index];
                    return _MessageBubble(message: message, isMine: message.isMine(_currentUserId));
                  },
                );
              },
            ),

            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 12.h,
              child: _FloatingMessageInput(controller: _messageController, onSend: _send),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMine});

  final MessageEntity message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final metaColor = isMine ? Colors.white70 : AppColors.mediumTextColor;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primaryColor : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isMine ? 16.r : 4.r),
            bottomRight: Radius.circular(isMine ? 4.r : 16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: TextStyle(fontSize: 14.sp, color: isMine ? Colors.white : AppColors.largeTextColor),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 10.sp, color: metaColor),
                ),
                // أيقونة الساعة لحد ما الرسالة تتأكد من السيرفر.
                if (message.isPending) ...[
                  SizedBox(width: 4.w),
                  Icon(Icons.access_time, size: 10.sp, color: metaColor),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingMessageInput extends StatelessWidget {
  const _FloatingMessageInput({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 18.w, right: 6.w, top: 4.h, bottom: 4.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: AppColors.mediumTextColor, fontSize: 14.sp),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          InkWell(
            onTap: onSend,
            customBorder: const CircleBorder(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
              child: Icon(Icons.send_rounded, color: Colors.white, size: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
}