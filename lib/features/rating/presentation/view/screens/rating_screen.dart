import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/rating/presentation/view_model/rating_cubit.dart';
import 'package:uni_help/features/rating/presentation/view_model/rating_state_cubit.dart';

class RateHelperScreen extends StatelessWidget {
  const RateHelperScreen({
    super.key,
    required this.targetUserId,
    required this.targetUserName,
    this.requestId,
  });

  final String targetUserId;
  final String targetUserName;
  final String? requestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<RateHelperCubit>(),
      child: _RateHelperView(
        targetUserId: targetUserId,
        targetUserName: targetUserName,
        requestId: requestId,
      ),
    );
  }
}

class _RateHelperView extends StatefulWidget {
  const _RateHelperView({
    required this.targetUserId,
    required this.targetUserName,
    this.requestId,
  });

  final String targetUserId;
  final String targetUserName;
  final String? requestId;

  @override
  State<_RateHelperView> createState() => _RateHelperViewState();
}

class _RateHelperViewState extends State<_RateHelperView> {
  int _stars = 0;
  final _commentController = TextEditingController();

  String get _initials {
    final parts = widget.targetUserName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Rate Your Helper'),
      ),
      body: BlocConsumer<RateHelperCubit, RateHelperStateCubit>(
        listener: (context, state) {
          if (state is RateHelperStateSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thanks for your feedback!')),
            );
          }
          if (state is RateHelperStateError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isSubmitting = state is RateHelperStateSubmitting;

          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                CircleAvatar(
                  radius: 36.r,
                  backgroundColor: AppColors.primaryColor,
                  child: Text(_initials, style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 12.h),
                Text(widget.targetUserName,
                    style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor)),
                SizedBox(height: 4.h),
                Text('How was your experience?', style: TextStyle(fontSize: 13.sp, color: AppColors.mediumTextColor)),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final starIndex = i + 1;
                    return IconButton(
                      onPressed: () => setState(() => _stars = starIndex),
                      icon: Icon(
                        starIndex <= _stars ? Icons.star_rounded : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 32.sp,
                      ),
                    );
                  }),
                ),
                SizedBox(height: 24.h),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Add a comment (optional)',
                      style: TextStyle(fontSize: 13.sp, color: AppColors.largeTextColor, fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: _commentController,
                  maxLength: 200,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Share your experience...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_stars == 0 || isSubmitting)
                        ? null
                        : () => context.read<RateHelperCubit>().submit(
                              targetUserId: widget.targetUserId,
                              stars: _stars,
                              comment: _commentController.text,
                              requestId: widget.requestId,
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: isSubmitting
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}