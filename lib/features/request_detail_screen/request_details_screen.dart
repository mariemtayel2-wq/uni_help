import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart'; // لتشغيل فتح روابط الملفات خارجياً
import 'package:intl/intl.dart';
class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({required this.request, super.key, requestId});

  final RequestEntity request;

bool _isImage(String url) {
  final cleanUrl = url.split('?').first.toLowerCase();

  // 1. التأكد أولاً أنه ليس ملف مستندات (PDF, DOCX...)
  if (cleanUrl.endsWith('.pdf') ||
      cleanUrl.endsWith('.doc') ||
      cleanUrl.endsWith('.docx') ||
      cleanUrl.endsWith('.txt') ||
      cleanUrl.endsWith('.zip')) {
    return false;
  }

  // 2. التحقق من امتدادات الصور الشهيرة
  return cleanUrl.endsWith('.jpg') ||
      cleanUrl.endsWith('.jpeg') ||
      cleanUrl.endsWith('.png') ||
      cleanUrl.endsWith('.webp') ||
      cleanUrl.endsWith('.gif') ||
      (url.contains('/image/upload/') && !url.contains('.pdf'));
}Future<void> _openFile(String url) async {
  final uri = Uri.parse(url);
  try {
    await launchUrl(
      uri, 
      mode: LaunchMode.externalApplication, // يفتحه في المتصفح الخارجي أو قارئ الـ PDF
    );
  } catch (e) {
    debugPrint("Error launching URL: $e");
  }
}

  // فتح عرض الصورة بحجم كامل عند الضغط عليها
  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: InteractiveViewer(
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18.sp, color: AppColors.largeTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Request Details',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  // Category
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      request.category,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Title & Description
                  Text(
                    request.title,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    request.description,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.mediumTextColor, height: 1.6),
                  ),
                  SizedBox(height: 20.h),

                  // Requester Profile Card
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: AppColors.primaryColor,
                          child: Text(
                            request.requesterInitials,
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.requesterName,
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.largeTextColor),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star_rounded, size: 14.sp, color: Colors.amber),
                                SizedBox(width: 2.w),
                                Text(
                                  '${request.requesterRating.toStringAsFixed(1)} (${request.requesterRatingCount} reviews)',
                                  style: TextStyle(fontSize: 12.sp, color: AppColors.mediumTextColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Attachments Section
                  if (request.attachments.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    Text(
                      'Attachments',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: request.attachments.map((attachmentUrl) {
                        final isImg = _isImage(attachmentUrl);

                        if (isImg) {
                          // 🖼️ عرض المرفق إذا كان صورة
                          return GestureDetector(
                            onTap: () => _showImageDialog(context, attachmentUrl),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                attachmentUrl,
                                width: 100.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildFileCard(attachmentUrl),
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 100.w,
                                    height: 100.h,
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          // 📄 عرض المرفق إذا كان ملف (PDF, DOCX, إلخ)
                          return GestureDetector(
                            onTap: () => _openFile(attachmentUrl),
                            child: _buildFileCard(attachmentUrl),
                          );
                        }
                      }).toList(),
                    ),
                  ],

                  // Request Info
                  if (request.preferredTime != null || request.location != null || request.availability != null) ...[
                    SizedBox(height: 24.h),
                    Text(
                      'Request Info',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
                    ),
                    SizedBox(height: 10.h),
                    if (request.preferredTime != null)
_InfoRow(
  icon: Icons.access_time_rounded,
  label: 'Preferred Time',
  value: request.preferredTime != null
      ? DateFormat('d MMM, h:mm a').format(request.preferredTime!)
      : 'Not specified',
),                    if (request.location != null)
                      _InfoRow(icon: Icons.location_on_outlined, label: 'Location', value: request.location!),
                    if (request.availability != null)
                      _InfoRow(icon: Icons.check_circle_outline, label: 'Availability', value: request.availability!),
                  ],
                ],
              ),
            ),

            // Bottom Action Button
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: Text(
                    'Offer Help',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // كارت خاص بالملفات المستندات
  Widget _buildFileCard(String url) {
    final fileName = Uri.parse(url).pathSegments.last;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_drive_file_outlined, color: AppColors.primaryColor, size: 22.sp),
          SizedBox(width: 8.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150.w),
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.largeTextColor),
            ),
          ),
          SizedBox(width: 6.w),
          Icon(Icons.open_in_new, color: AppColors.mediumTextColor, size: 16.sp),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: AppColors.mediumTextColor),
          SizedBox(width: 10.w),
          Text(label, style: TextStyle(fontSize: 13.sp, color: AppColors.mediumTextColor)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.largeTextColor),
          ),
        ],
      ),
    );
  }
}