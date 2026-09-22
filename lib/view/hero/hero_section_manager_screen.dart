import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/app_sizes.dart';
import 'package:storio_app/widget/skeleton/hero_sliderow_skeleton.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/universal/custom_app_bar.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';

import '../../data/model/hero/hero_slide_model.dart';
import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/hero_slide_view_model.dart';
import '../../widget/hero/preview_mode_button_row.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_card.dart';

class HeroSectionManagerScreen extends StatefulWidget {
  const HeroSectionManagerScreen({super.key});

  @override
  State<HeroSectionManagerScreen> createState() =>
      _HeroSectionManagerScreenState();
}

class _HeroSectionManagerScreenState extends State<HeroSectionManagerScreen> {
  final TextEditingController searchController = TextEditingController();

  int selectedPreviewIndex = 0;

  final List<String> previewModes = ["Desktop", "Tablet", "Mobile"];

  final List<IconData> previewIcons = [
    Icons.desktop_windows,
    Icons.tablet,
    Icons.phone_android,
  ];

  // Multi-select state for bulk delete
  final Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<HeroSlideViewModel>();
      await provider.getManagementHeroSlideApi(isFilterOrSearch: false);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _toggleSelectAll(bool? value, List<HeroSlideModel> list) {
    setState(() {
      if (value == true) {
        selectedIds
          ..clear()
          ..addAll(list.map((e) => e.id).whereType<int>());
      } else {
        selectedIds.clear();
      }
    });
  }

  void _toggleSelectOne(int? id, bool? value) {
    if (id == null) return;
    setState(() {
      if (value == true) {
        selectedIds.add(id);
      } else {
        selectedIds.remove(id);
      }
    });
  }

  Future<void> _handleBulkDelete() async {
    final confirmed = await confirmAction(
      context,
      title: "Delete Hero Slides",
      message:
          "Are you sure you want to permanently delete ${selectedIds.length} selected hero slide(s)?",
    );

    if (!mounted || !confirmed) return;

    final provider = context.read<HeroSlideViewModel>();
    final success = await provider.bulkAction(selectedIds.toList());

    if (!mounted) return;

    if (success) {
      setState(() => selectedIds.clear());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.managementErrorMessage ?? "Bulk delete failed",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Hero Section Manager",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.only(
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
              top: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search + bulk delete action (right side)
                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(
                            onChanged: (value) {
                              final provider = context
                                  .read<HeroSlideViewModel>();
                              provider.getManagementHeroSlideApi(
                                search: value,
                                isFilterOrSearch: true,
                              );
                            },
                            hinText: "Search by heading",
                            controller: searchController,
                          ),
                        ),
                        if (selectedIds.isNotEmpty) ...[
                          SizedBox(width: AppSizes.appbarGap),
                          GestureDetector(
                            onTap: _handleBulkDelete,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.buttonRadius,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    "Delete (${selectedIds.length})",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // Hero slide table
                    Consumer<HeroSlideViewModel>(
                      builder: (context, provider, child) {
                        if (provider.managementLoading) {
                          return ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return HeroSlideRowSkeleton();
                            },
                          );
                        }

                        if (provider.managementErrorMessage != null) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(provider.managementErrorMessage!),
                            ),
                          );
                        }

                        final list = provider.managementHeroSlideList;

                        if (list.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(child: Text("No hero slides found")),
                          );
                        }

                        // Drop stale selected ids no longer in the list
                        selectedIds.retainWhere(
                          (id) => list.any((e) => e.id == id),
                        );

                        final allSelected =
                            list.isNotEmpty &&
                            selectedIds.length == list.length;
                        final someSelected =
                            selectedIds.isNotEmpty && !allSelected;

                        return CustomCard(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 222.w,
                              child: Column(
                                children: [
                                  // ================= HEADER =================
                                  Container(
                                    height: 4.5.h,
                                    decoration: BoxDecoration(
                                      color: color.primary.withOpacity(0.06),
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 14.w,
                                          child: Center(
                                            child: Checkbox(
                                              value: allSelected,
                                              tristate: true,

                                              activeColor: color.primary,
                                              checkColor: Colors.white,
                                              onChanged: (value) {
                                                // 3-state tap cycle: unchecked/mixed -> select all, checked -> clear
                                                _toggleSelectAll(
                                                  someSelected
                                                      ? true
                                                      : !allSelected,
                                                  list,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 110.w,
                                          child: Text(
                                            "SUPER CONTENT",
                                            style: TextStyle(
                                              color: color.primary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 38.w,
                                          child: Text(
                                            "BUTTON & LINK",
                                            style: TextStyle(
                                              color: color.primary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25.w,
                                          child: Text(
                                            "STATUS",
                                            style: TextStyle(
                                              color: color.primary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 31.w,
                                          child: Text(
                                            "ACTIONS",
                                            style: TextStyle(
                                              color: color.primary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      final slide = list[index];

                                      return _superContentRow(
                                        context: context,
                                        slide: slide,
                                        isSelected:
                                            slide.id != null &&
                                            selectedIds.contains(slide.id),
                                        onSelectChanged: (value) =>
                                            _toggleSelectOne(slide.id, value),
                                        onEdit: () async {
                                          final result =
                                              await Navigator.pushNamed(
                                                context,
                                                RoutesName.add_new_hero_slide,
                                                arguments: {'heroSlide': slide},
                                              );

                                          if (!mounted) return;

                                          if (result == true) {
                                            _refreshHeroSlideList();
                                          }
                                        },
                                        onCopy: () async {
                                          final data = slide.toJson();
                                          data.remove('id');
                                          data['heading'] =
                                              "${slide.heading ?? ''} (Copy)";

                                          final provider2 = context
                                              .read<HeroSlideViewModel>();
                                          final success = await provider2
                                              .createHeroSlide(data);

                                          if (!mounted) return;

                                          if (success) {
                                            _refreshHeroSlideList();
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  provider2
                                                          .managementErrorMessage ??
                                                      "Failed to duplicate slide",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        onDelete: () async {
                                          final confirmed = await confirmAction(
                                            context,
                                            title: "Delete Hero Slide",
                                            message:
                                                "Are you sure you want to permanently delete this hero slide?",
                                          );

                                          if (!mounted || !confirmed) return;

                                          final provider2 = context
                                              .read<HeroSlideViewModel>();
                                          final success = await provider2
                                              .deleteHeroSlide(slide.id!);

                                          if (!mounted) return;

                                          if (success) {
                                            setState(() {
                                              selectedIds.remove(slide.id);
                                            });
                                            _refreshHeroSlideList();
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  provider2
                                                          .managementErrorMessage ??
                                                      "Failed to delete",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // Frontend Preview
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextTitleWidget(
                          title: "Frontend Preview",
                          color: color.primary,
                        ),
                        SizedBox(height: AppSizes.appbarGap),

                        PreviewModeButtonRow(
                          items: previewModes,
                          icons: previewIcons,
                          selectedIndex: selectedPreviewIndex,
                          onSelected: (index) {
                            setState(() {
                              selectedPreviewIndex = index;
                            });
                          },
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        Consumer<HeroSlideViewModel>(
                          builder: (context, provider, child) {
                            final activeSlides = provider
                                .managementHeroSlideList
                                .where(
                                  (s) =>
                                      (s.status ?? 'active').toLowerCase() ==
                                      'active',
                                )
                                .toList();

                            final previewSlides = activeSlides.isNotEmpty
                                ? activeSlides
                                : provider.managementHeroSlideList;

                            late final double width;
                            late final double aspectRatio;

                            if (selectedPreviewIndex == 0) {
                              width = 800;
                              aspectRatio = 16 / 7;
                            } else if (selectedPreviewIndex == 1) {
                              width = 550;
                              aspectRatio = 4 / 3;
                            } else {
                              width = 320;
                              aspectRatio = 9 / 16;
                            }

                            return Center(
                              child: Container(
                                width: width,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.buttonRadius,
                                  ),
                                ),
                                child: _FrontendPreviewCarousel(
                                  key: ValueKey(
                                    'preview_$selectedPreviewIndex',
                                  ),
                                  slides: previewSlides,
                                  width: width,
                                  aspectRatio: aspectRatio,
                                  fallbackColor: color.primary,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                    SizedBox(height: AppSizes.sectionGap),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                RoutesName.add_new_hero_slide,
              );

              if (!mounted) return;

              if (result == true) {
                _refreshHeroSlideList();
              }
            },
            child: Icon(Icons.add, color: color.cardBackground),
          ),
        ],
      ),
    );
  }

  void _refreshHeroSlideList() {
    final provider = context.read<HeroSlideViewModel>();
    provider.getManagementHeroSlideApi(
      search: searchController.text,
      isFilterOrSearch: true,
    );
  }
}

// ================================================================
// Table row
// ================================================================
Widget _superContentRow({
  required BuildContext context,
  required HeroSlideModel slide,
  required bool isSelected,
  required ValueChanged<bool?> onSelectChanged,
  required VoidCallback onEdit,
  required VoidCallback onCopy,
  required VoidCallback onDelete,
}) {
  final color = context.Appcolor;
  final imageUrl = slide.bgImageData?.file;

  return Container(
    height: 8.5.h,
    decoration: BoxDecoration(
      color: isSelected ? color.primary.withOpacity(0.05) : null,
      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
    ),
    child: Row(
      children: [
        // Checkbox
        SizedBox(
          width: 14.w,
          child: Center(
            child: Checkbox(
              activeColor: color.primary,
              checkColor: Colors.white,
              value: isSelected,
              onChanged: onSelectChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),

        // Super content
        SizedBox(
          width: 110.w,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width: 10.w,
                        height: 5.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              'assets/images/institute.png',
                              width: 10.w,
                              height: 5.h,
                              fit: BoxFit.cover,
                            ),
                      )
                    : Image.asset(
                        'assets/images/institute.png',
                        width: 10.w,
                        height: 5.h,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(width: 2.w),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTitleWidget(
                      title: slide.heading ?? "",
                      color: color.primary,
                      maxLines: 1,
                    ),
                    SizedBox(height: AppSizes.appbarGap),
                    TextBodyStyleWidget(
                      title: slide.subheading ?? "",
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Button link
        SizedBox(
          width: 36.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextTitleWidget(
                title: slide.buttonText ?? "",
                color: color.primary,
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.appbarGap),
              TextBodyStyleWidget(title: slide.buttonLink ?? "", maxLines: 1),
            ],
          ),
        ),
        SizedBox(width: 2.w),

        // Status
        SizedBox(
          width: 25.w,
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomStatusBadge(
              title: (slide.status ?? "active").toUpperCase(),
            ),
          ),
        ),

        // Action buttons
        SizedBox(
          width: 31.w,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit
              GestureDetector(
                onTap: onEdit,
                child: Icon(
                  Icons.edit,
                  size: AppSizes.iconLarge,
                  color: color.primary,
                ),
              ),
              SizedBox(width: AppSizes.itemGap),

              // Copy
              GestureDetector(
                onTap: onCopy,
                child: Icon(
                  Icons.copy,
                  size: AppSizes.iconLarge,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: AppSizes.itemGap),

              // Delete
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.delete_outline_outlined,
                  size: AppSizes.iconLarge,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ================================================================
// Frontend Preview — auto-sliding carousel (mimics the live website)
// ================================================================
class _FrontendPreviewCarousel extends StatefulWidget {
  final List<HeroSlideModel> slides;
  final double width;
  final double aspectRatio;
  final Color fallbackColor;

  const _FrontendPreviewCarousel({
    super.key,
    required this.slides,
    required this.width,
    required this.aspectRatio,
    required this.fallbackColor,
  });

  @override
  State<_FrontendPreviewCarousel> createState() =>
      _FrontendPreviewCarouselState();
}

class _FrontendPreviewCarouselState extends State<_FrontendPreviewCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(covariant _FrontendPreviewCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slides.length != widget.slides.length) {
      _currentPage = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (widget.slides.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_currentPage + 1) % widget.slides.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Color? _hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    var cleaned = hex.replaceAll('#', '').trim();
    if (cleaned.length == 6) cleaned = 'FF$cleaned';
    try {
      return Color(int.parse(cleaned, radix: 16));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Image.asset('assets/images/institute.png', fit: BoxFit.cover),
      );
    }

    return SizedBox(
      width: widget.width,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.slides.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) =>
                  _buildSlide(widget.slides[index]),
            ),

            // Dot indicators
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.slides.length, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 10 : 8,
                    height: isActive ? 10 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(HeroSlideModel slide) {
    final imageUrl = slide.bgImageData?.file ?? slide.bgImageUrl;
    final gradientFrom = _hexToColor(slide.gradientFrom);
    final gradientTo = _hexToColor(slide.gradientTo);
    final bgColor = _hexToColor(slide.bgColor);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background layer
        if (slide.bgType == 'gradient' &&
            gradientFrom != null &&
            gradientTo != null)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradientFrom, gradientTo],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          )
        else if (slide.bgType == 'color' && bgColor != null)
          Container(color: bgColor)
        else if (imageUrl != null)
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset('assets/images/institute.png', fit: BoxFit.cover),
          )
        else
          Image.asset('assets/images/institute.png', fit: BoxFit.cover),

        // Dark scrim for text legibility (matches typical hero overlays)
        Container(color: Colors.black.withOpacity(0.22)),

        // Text content
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if ((slide.heading ?? '').isNotEmpty)
                  Text(
                    slide.heading!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _hexToColor(slide.headingColor) ?? Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                if ((slide.subheading ?? '').isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    slide.subheading!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          _hexToColor(slide.subheadingColor) ?? Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
                if ((slide.buttonText ?? '').isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _hexToColor(slide.buttonColor) ??
                          widget.fallbackColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      slide.buttonText!,
                      style: TextStyle(
                        color:
                            _hexToColor(slide.buttonTextColor) ?? Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
