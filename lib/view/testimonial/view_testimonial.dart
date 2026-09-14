import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/data/model/Content/testimonial/testimonial_model.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/testimonial_view_model.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_status_badge.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/info_row_widget.dart';

class ViewTestimonial extends StatefulWidget {
  const ViewTestimonial({super.key, required this.testimonial});

  final TestimonialModel testimonial;

  @override
  State<ViewTestimonial> createState() => _ViewTestimonialState();
}

class _ViewTestimonialState extends State<ViewTestimonial> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<TestimonialViewModel>();
      viewModel.selectedTestimonial = widget.testimonial;
    });
  }

  Widget _buildRating(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }



  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: Consumer<TestimonialViewModel>(
        builder: (context, viewModel, child) {
          final testimonial = viewModel.selectedTestimonial ?? widget.testimonial;

          return CustomScrollView(
            slivers: [
              CustomSliverAppBar(
                title: testimonial.name ?? "",
                subtitle: testimonial.organization ?? "",
                showBackButton: true,
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                  top: AppSizes.screenPadding,
                  left: AppSizes.screenPadding,
                  right: AppSizes.screenPadding,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: [
                        ImageCard(
                          image: testimonial.photoData?.fileUrl != null
                              ? Image.network(
                            testimonial.photoData!.fileUrl!,
                            width: double.infinity,
                            height: 18.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                  "assets/images/institute.png",
                                  width: double.infinity,
                                  height: 18.h,
                                  fit: BoxFit.fitHeight,
                                ),
                          )
                              : Image.asset(
                            "assets/images/person.png",
                            width: double.infinity,
                            height: 14.h,
                            fit: BoxFit.fitHeight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: AppSizes.appbarGap,),

                                  Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: AppSizes.smallPadding),
                                    child: Row(mainAxisAlignment: .spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: .start,
                                          children: [
                                            CustomStatusBadge(
                                              title: testimonial.status?.toUpperCase() ?? "",
                                              size: AppSizes.cardTitle,
                                            ),
                                            SizedBox(height: AppSizes.smallGap,),

                                            // STARS
                                            _buildRating(testimonial.rating ?? 0),
                                          ],
                                        ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  RoutesName.edit_testimonial,
                                                  arguments: {
                                                    'testimonial': testimonial,
                                                  },
                                                );
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                size: AppSizes.iconLarge,
                                                color: color.primary,
                                              ),
                                            ),

                                      ],
                                    ),
                                  ),

                              SizedBox(height: AppSizes.itemGap),
                              CustomCard2(
                                child: Padding(
                                  padding: EdgeInsets.all(AppSizes.contentPadding),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InfoRowWidget(
                                        icon: Icons.apartment_outlined,
                                        title: "Company",
                                        value: testimonial.designation ?? "",
                                      ),
                                      SizedBox(height: AppSizes.smallGap),
                                      InfoRowWidget(
                                        icon: Icons.message_outlined,
                                        title: "Testimonial Message",
                                        value: "",
                                      ),
                                      SizedBox(height: AppSizes.appbarGap),
                                      TextBodyStyleWidget(
                                        title: testimonial.message ?? "",
                                        size: AppSizes.cardTitle,
                                        fontbold: false,
                                        color: color.textPrimary,
                                        maxLines: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}