import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// شيمر لشاشة الشات (فقاعات رسايل بتتبدل يمين وشمال).
class ChatShimmer extends StatelessWidget {
  const ChatShimmer({super.key});

  static const _widthFactors = [0.5, 0.65, 0.4, 0.7, 0.55, 0.45, 0.6, 0.5];
  static const _heights = [44.0, 60.0, 44.0, 70.0, 44.0, 56.0, 44.0, 60.0];

  @override
  Widget build(BuildContext context) {
    return _ShimmerEffect(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 90.h),
        itemCount: _widthFactors.length,
        itemBuilder: (context, index) {
          final isMine = index.isOdd;
          return Align(
            alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: _widthFactors[index] * 0.75.sw,
              height: _heights[index].h,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(isMine ? 16.r : 4.r),
                  bottomRight: Radius.circular(isMine ? 4.r : 16.r),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// شيمر لشاشة قائمة المحادثات (كروت: صورة + سطرين + وقت).
class ChatsListShimmer extends StatelessWidget {
  const ChatsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShimmerEffect(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        itemCount: 8,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
            child: Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bar(width: 120.w, height: 14.h),
                      SizedBox(height: 8.h),
                      _Bar(width: 200.w, height: 12.h),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                _Bar(width: 30.w, height: 10.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(6.r)),
    );
  }
}

/// تأثير اللمعة المتحركة (من غير أي package خارجي).
class _ShimmerEffect extends StatefulWidget {
  const _ShimmerEffect({required this.child});

  final Widget child;

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.grey.shade300, Colors.grey.shade100, Colors.grey.shade300],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlidingGradientTransform(-1 + 2 * _controller.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}