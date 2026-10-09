import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppImageShimmer extends StatelessWidget {
  const AppImageShimmer({
    super.key,
    this.baseColor = const Color(0xFF3B465D),
    this.highlightColor = const Color(0x1FFFFFFF),
    this.backgroundColor = const Color(0xFF2F384D),
  });

  final Color baseColor;
  final Color highlightColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ColoredBox(color: backgroundColor),
    );
  }
}
