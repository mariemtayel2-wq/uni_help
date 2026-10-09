import 'package:flutter/material.dart';
import 'package:uni_help/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onPressed,
    required this.text,
    required this.width,
    required this.height,
    super.key,
    this.lastRadius,
    this.threeRadius,
    this.backgroundColor,
    this.textColor,
    this.textAlign,
    this.textStyle,
    this.isLoading = false,
    this.loadingWidth = 30,
    this.loadingHeight = 30,
    this.borderColor,
  });

  final Color? borderColor;
  final VoidCallback onPressed;
  final String text;
  final TextStyle ?textStyle;
  final double width;
  final double height;
  final double? threeRadius;
  final double? lastRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final TextAlign? textAlign;
  final double? loadingWidth;
  final double? loadingHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.largeTextColor,
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(threeRadius ?? 8),
              topRight: Radius.circular(threeRadius ?? 8),
              bottomRight: Radius.circular(threeRadius ?? 8),
              bottomLeft: Radius.circular(lastRadius ?? 8),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(textAlign: textAlign, text, style: textStyle ?? TextStyle(color: textColor ?? Colors.white)),
      ),
    );
  }
}
