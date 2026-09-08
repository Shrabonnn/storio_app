import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/data/model/Content/notice/notice_model.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_status_badge.dart';
import '../../widget/universal/date_time_formate.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/info_item_card.dart';

class ViewNoticeScreen extends StatefulWidget {
  const ViewNoticeScreen({super.key, required this.notice});
  final NoticeModel notice;

  @override
  State<ViewNoticeScreen> createState() => _ViewNoticeScreenState();
}

class _ViewNoticeScreenState extends State<ViewNoticeScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:widget.notice.title ?? "",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_month_outlined,color: color.primary,size: AppSizes.icon,),
                                  SizedBox(width: AppSizes.appbarGap,),
                                  Flexible(child: TextBodyStyleWidget(title: "Last Updated: ${formatDate(widget.notice.updateDate!)} · ${formatTime(widget.notice.updateDate!)}",maxLines: 2,size: AppSizes.cardTitle)),
                                ],
                              ),
                            ),
                            CustomStatusBadge(title: widget.notice.status ?? "",size: AppSizes.cardTitle,),
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        CustomCard2(child: Padding(
                          padding:  EdgeInsets.all(AppSizes.contentPadding),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              TextBodyStyleWidget(title: widget.notice.content ?? ""
                                ,color: color.primary,
                                fontbold: false
                                ,size: AppSizes.cardTitle,maxLines: 20,),


                            ],
                          ),
                        )),

                      ],
                    ))
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
