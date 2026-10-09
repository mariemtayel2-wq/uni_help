import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  static TextStyle bold28Px = GoogleFonts.plusJakartaSans(
  fontSize: 28.sp,
  fontWeight: FontWeight.w700,
);
  static TextStyle bold36Px = GoogleFonts.plusJakartaSans(
  fontSize: 36.sp,
  fontWeight: FontWeight.w700,
);
  static TextStyle regular16Px = GoogleFonts.inter(
  fontSize: 16.sp,
  fontWeight: FontWeight.w400,
);
 static TextStyle semiBold14Px = GoogleFonts.inter(
  fontSize: 14.sp,
  fontWeight: FontWeight.w600,
);
static TextStyle medium16Px = GoogleFonts.inter(
  fontSize: 16.sp,
  fontWeight: FontWeight.w500,
);
static TextStyle medium12Px = GoogleFonts.inter(
  fontSize: 12.sp,
  fontWeight: FontWeight.w500,
);
static TextStyle semiBold20Px = GoogleFonts.inter(
  fontSize: 20.sp,
  fontWeight: FontWeight.w600,
);
static TextStyle bold48Px = GoogleFonts.inter(
  fontSize: 48.sp,
  fontWeight: FontWeight.w700,
);
  
}
