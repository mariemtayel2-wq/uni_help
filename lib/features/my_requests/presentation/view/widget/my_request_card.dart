import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/core/theme/app_colors.dart';

class MyRequestCard extends StatelessWidget {
  const MyRequestCard({
    super.key,
    required this.request,
    required this.onDelete,
    required this.onMarkDone,
  });

  final RequestEntity request;
  final VoidCallback onDelete;
  final VoidCallback onMarkDone;

  Color _statusColor() {
    switch (request.status) {
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.inProgress:
        return Colors.blue;
      case RequestStatus.completed:
        return Colors.green;
      case RequestStatus.cancelled:
        return Colors.grey;
    }
  }

  String _statusLabel() {
    switch (request.status) {
      case RequestStatus.pending:
        return 'Waiting for a helper';
      case RequestStatus.inProgress:
        return 'In progress with ${request.helperName ?? "a helper"}';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(request.title,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(color: _statusColor().withOpacity(0.12), borderRadius: BorderRadius.circular(8.r)),
                child: Text(_statusLabel(), style: TextStyle(fontSize: 10.sp, color: _statusColor(), fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(request.description, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp, color: AppColors.mediumTextColor)),
          SizedBox(height: 12.h),
          Row(
            children: [
              if (request.status == RequestStatus.inProgress)
                Expanded(child: OutlinedButton(onPressed: onMarkDone, child: const Text('Mark as Done'))),
              if (request.status == RequestStatus.inProgress) SizedBox(width: 8.w),
              if (request.status == RequestStatus.pending)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDelete,
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}