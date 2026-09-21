import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/constant/request_category.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/explore_screen/presentation/utils/explore_shimmer.dart';
import 'package:uni_help/features/explore_screen/presentation/view_model/explore_cubit.dart';
import 'package:uni_help/features/explore_screen/presentation/view_model/explore_state.dart';
import 'package:uni_help/features/home_screen/presentation/view/screens/request_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ExploreCubit>()..loadExplore(),
      child: const _ExploreView(),
    );
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView();

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.largeTextColor,
                ),
              ),
              SizedBox(height: 16.h),

              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.mediumTextColor, size: 20.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => context.read<ExploreCubit>().search(value),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search requests, topics...',
                          hintStyle: TextStyle(
                            color: AppColors.mediumTextColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Category Chips
              BlocBuilder<ExploreCubit, ExploreState>(
                buildWhen: (previous, current) => current is ExploreLoaded,
                builder: (context, state) {
                  final selected = state is ExploreLoaded ? state.selectedCategory : 'All';

                  return SizedBox(
                    height: 36.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: requestCategories.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      itemBuilder: (context, index) {
                        final category = requestCategories[index];
                        final isSelected = category == selected;

                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) {
                            if (_searchController.text.isNotEmpty) {
                              _searchController.clear();
                            }
                            context.read<ExploreCubit>().changeCategory(category);
                          },
                          backgroundColor: AppColors.white,
                          selectedColor: AppColors.primaryColor,
                          labelStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.mediumTextColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: BorderSide.none,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),

              // Results Section with Shimmer
              Expanded(
                child: BlocBuilder<ExploreCubit, ExploreState>(
                  builder: (context, state) {
                    if (state is ExploreLoading || state is ExploreInitial) {
                      return const ExploreScreenShimmer();                    }

                    if (state is ExploreError) {
                      return Center(
                        child: Text(state.message, textAlign: TextAlign.center),
                      );
                    }

                    final loaded = state as ExploreLoaded;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${loaded.results.length} results',
                          style: TextStyle(fontSize: 13.sp, color: AppColors.mediumTextColor),
                        ),
                        SizedBox(height: 10.h),
                        Expanded(
                          child: loaded.results.isEmpty
                              ? Center(
                                  child: Text(
                                    'No results found',
                                    style: TextStyle(color: AppColors.mediumTextColor),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.only(bottom: 120.h),
                                  itemCount: loaded.results.length,
                                  itemBuilder: (context, index) {
                                    final r = loaded.results[index];
                                    return RequestCard(request: r);
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}