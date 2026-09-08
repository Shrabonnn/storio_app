import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/info_item_card.dart';

import '../../data/model/Content/blog/blog_model.dart';
import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../viewModel/Content/blog_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/date_time_formate.dart';
import '../../widget/universal/image_card.dart';

class ViewBlogScreen extends StatefulWidget {
  const ViewBlogScreen({
    super.key,
    required this.blog,
  });

  final BlogModel blog;

  @override
  State<ViewBlogScreen> createState() => _ViewBlogScreenState();
}

class _ViewBlogScreenState extends State<ViewBlogScreen> {
  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Post Details: ${widget.blog.title}",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      ImageCard(
                        image: widget.blog.featuredImageData?.file != null
                            ? Image.network(
                          widget.blog.featuredImageData!.file!,
                          width: double.infinity,
                          height: 18.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            "assets/images/institute.png",
                            width: double.infinity,
                            height: 18.h,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Image.asset(
                          "assets/images/institute.png",
                          width: double.infinity,
                          height: 18.h,
                          fit: BoxFit.cover,
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // =================================================
                            // AUTHOR & CATEGORY
                            // =================================================
                            Row(
                              children: [
                                Expanded(
                                  child: InfoItemCard(
                                    title: "Author",
                                    name: widget.blog.author ?? "",
                                    icons: Icons.person,
                                  ),
                                ),

                                SizedBox(
                                  width: AppSizes.smallGap,
                                ),

                                Expanded(
                                  child: InfoItemCard(
                                    title: "Category",
                                    name: widget.blog.categoriesData?.isNotEmpty ==true? widget.blog.categoriesData!.first.name?? "" :"UnCategrozied" ,
                                    icons: Icons.category_outlined,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: AppSizes.smallGap,
                            ),

                            // =================================================
                            // PUBLISHED DATE & STATUS
                            // =================================================
                            Row(
                              children: [
                                Expanded(
                                  child: InfoItemCard(
                                    title: "Published Date",
                                    name:  widget.blog.publishDate != null
                                        ? formatDate(widget.blog.publishDate!)
                                        : "",
                                    icons: Icons.calendar_month_outlined,
                                  ),
                                ),

                                SizedBox(
                                  width: AppSizes.smallGap,
                                ),

                                Expanded(
                                  child: InfoItemCard(
                                    title: "Status",
                                    name: widget.blog.status ?? "",
                                    icons: Icons.star,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: AppSizes.smallGap,
                            ),

                            // =================================================
                            // CONTENT
                            // =================================================
                            CustomCard2(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  AppSizes.contentPadding,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    TextTitleWidget(
                                      title: "Content",
                                      color: color.primary,
                                      size: AppSizes.screenTitle,
                                    ),

                                    SizedBox(
                                      height: AppSizes.smallGap,
                                    ),

                                    TextBodyStyleWidget(
                                      title: widget.blog.content ?? "",
                                      color: color.primary,
                                      size: AppSizes.cardTitle,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}