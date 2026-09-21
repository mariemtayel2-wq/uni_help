import 'dart:io';
import 'package:file_picker/file_picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:uni_help/core/common/widget/app_toast.dart';
import 'package:uni_help/core/common/widget/custum_button.dart';
import 'package:uni_help/core/constant/request_category.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/create_request/presentation/view_model/create_request_cubit.dart';
import 'package:uni_help/features/create_request/presentation/view_model/create_request_state_cubit.dart';


class CreateRequestScreen extends StatelessWidget {
  final String currentUserId;

  const CreateRequestScreen({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<CreateRequestCubit>(),
      child: _CreateRequestView(currentUserId: currentUserId),
    );
  }
}

class _CreateRequestView extends StatefulWidget {
  final String currentUserId;

  const _CreateRequestView({required this.currentUserId});

  @override
  State<_CreateRequestView> createState() => _CreateRequestViewState();
}

class _CreateRequestViewState extends State<_CreateRequestView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillController = TextEditingController();

  String? _selectedCategory;
  File? _selectedAttachment;
  DateTime? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _skillController.dispose();
    super.dispose();
  }
Future<void> _pickFile() async {
  final result = await picker.FilePicker.pickFiles(
    type: picker.FileType.any,
  );

  if (result.isEmpty) return;

  final filePath = result.single.path;

  if (filePath == null) return;

  setState(() {
    _selectedAttachment = File(filePath);
  });
}
  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.largeTextColor, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Request',
          style: TextStyle(
            color: AppColors.largeTextColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<CreateRequestCubit, CreateRequestStateCubit>(
        listener: (context, state) {
          if (state is CreateRequestStateSuccess) {
            AppToast.showToast(
              context: context,
              title: 'Success',
              description: 'Request Created Successfully!',
              type: ToastificationType.success,
            );
            Navigator.pop(context);
          } else if (state is CreateRequestStateError) {
            AppToast.showToast(
              context: context,
              title: 'Error',
              description: state.message,
              type: ToastificationType.error,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is CreateRequestStateLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  _buildFieldLabel('Title', isRequired: true),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _titleController,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: _buildInputDecoration(hintText: 'E.g. Need help with Flutter MVI'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a title' : null,
                  ),
                  SizedBox(height: 16.h),

                  // Description with counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFieldLabel('Description', isRequired: true),
                      ValueListenableBuilder(
                        valueListenable: _descriptionController,
                        builder: (context, value, _) => Text(
                          '${_descriptionController.text.length}/500',
                          style: TextStyle(color: AppColors.mediumTextColor, fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _descriptionController,
                    maxLength: 500,
                    maxLines: 4,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: _buildInputDecoration(hintText: 'Explain your problem in detail...').copyWith(
                      counterText: '',
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a description' : null,
                  ),
                  SizedBox(height: 16.h),

                  // Category
                  _buildFieldLabel('Category', isRequired: true),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    icon: Icon(Icons.keyboard_arrow_down, color: AppColors.mediumTextColor),
                    decoration: _buildInputDecoration(hintText: 'Select category'),
                    items: requestCategories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat, style: TextStyle(fontSize: 14.sp, color: AppColors.largeTextColor)),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                    validator: (v) => v == null ? 'Please select a category' : null,
                  ),
                  SizedBox(height: 16.h),

                  // Skill Needed
                  _buildFieldLabel('Skill Needed', isRequired: true),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _skillController,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: _buildInputDecoration(hintText: 'Flutter'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter required skill' : null,
                  ),
                  SizedBox(height: 16.h),

                  // Add Attachment
                  _buildFieldLabel('Add Attachment', isOptional: true),
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: _pickFile,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_upload_outlined, color: AppColors.mediumTextColor, size: 28.sp),
                          SizedBox(height: 6.h),
                          Text(
                            _selectedAttachment == null
                                ? 'Tap to upload\nimages, files (max 10MB)'
                                : _selectedAttachment!.path.split('/').last,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.mediumTextColor, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Preferred Time
                  _buildFieldLabel('Preferred Time', isOptional: true),
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: _pickDateTime,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedTime == null
                                ? 'Select time'
                                : '${_selectedTime!.day}/${_selectedTime!.month}/${_selectedTime!.year}  ${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: _selectedTime == null ? AppColors.mediumTextColor : AppColors.largeTextColor,
                              fontSize: 14.sp,
                            ),
                          ),
                          Icon(Icons.calendar_today_outlined, color: AppColors.mediumTextColor, size: 18.sp),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Custom Button Usage
                  CustomButton(
                    text: 'Post Request',
                    width: double.infinity,
                    height: 48.h,
                    backgroundColor: AppColors.primaryColor,
                    threeRadius: 24.r,
                    lastRadius: 24.r,
                    isLoading: isLoading,
                    textStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    onPressed: isLoading
                        ? () {}
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<CreateRequestCubit>().submitRequest(
                                    title: _titleController.text.trim(),
                                    description: _descriptionController.text.trim(),
                                    category: _selectedCategory!,
                                    skillNeeded: _skillController.text.trim(),
                                    attachment: _selectedAttachment,
                                    preferredTime: _selectedTime,
                                    userId: widget.currentUserId,
                                  );
                            }
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false, bool isOptional = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.largeTextColor,
        ),
        children: [
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
            ),
          if (isOptional)
            TextSpan(
              text: ' (optional)',
              style: TextStyle(color: AppColors.mediumTextColor, fontWeight: FontWeight.normal, fontSize: 12.sp),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.mediumTextColor, fontSize: 13.sp),
      fillColor: AppColors.white,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
    );
  }
}