import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/info_row_widget.dart';

import '../../../data/model/organization/leader_message/leadership_message_model.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/image_card.dart';
import '../../../widget/universal/image_circle_widget.dart';

class ViewLeadershipMessage extends StatefulWidget {
  const ViewLeadershipMessage({super.key, required this.message});

  final LeadershipMessageModel message;

  @override
  State<ViewLeadershipMessage> createState() => _ViewLeadershipMessageState();
}

class _ViewLeadershipMessageState extends State<ViewLeadershipMessage> {
  String _formatStatus(String? status) {
    if (status == null || status.isEmpty) return "-";
    return status[0].toUpperCase() + status.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    final message = widget.message;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: message.name ?? "-",
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
                    ImageCard(
                      image: message.imageData?.fileUrl != null
                          ? Image.network(
                        message.imageData!.fileUrl!,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomStatusBadge(
                                title: _formatStatus(message.status),
                                size: AppSizes.cardTitle,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesName.edit_leadership_message,
                                        arguments: {
                                          'message': message,
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
                            ],
                          ),
                          SizedBox(height: AppSizes.smallGap),
                          CustomCard2(
                            child: Padding(
                              padding: EdgeInsets.all(AppSizes.contentPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (message.sectionTitle != null &&
                                      message.sectionTitle!.isNotEmpty) ...[
                                    InfoRowWidget(
                                      icon: Icons.title,
                                      title: "Section",
                                      value: message.sectionTitle!,
                                    ),
                                    SizedBox(height: AppSizes.smallGap),
                                  ],
                                  InfoRowWidget(
                                    icon: Icons.badge,
                                    title: "Role",
                                    value: message.role ?? "-",
                                  ),
                                  SizedBox(height: AppSizes.smallGap),
                                  InfoRowWidget(
                                    icon: Icons.apartment_outlined,
                                    title: "Company",
                                    value: (message.company != null &&
                                        message.company!.isNotEmpty)
                                        ? message.company!
                                        : "-",
                                  ),
                                  SizedBox(height: AppSizes.smallGap),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.file_copy_outlined,
                                        color: color.primary,
                                        size: AppSizes.icon,
                                      ),
                                      SizedBox(width: AppSizes.appbarGap),
                                      Flexible(
                                        child: TextBodyStyleWidget(
                                          title:
                                          "Message: ${message.message ?? '-'}",
                                          color: color.primary,
                                          fontbold: false,
                                          maxLines: 35,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (message.signatureData?.fileUrl !=
                                      null &&
                                      message.signatureData!.fileUrl!
                                          .isNotEmpty) ...[
                                    SizedBox(height: AppSizes.sectionGap),
                                    TextBodyStyleWidget(
                                      title: "Digital Signature",
                                      color: color.primary,
                                      size: AppSizes.cardTitle,
                                    ),
                                    SizedBox(height: AppSizes.smallGap),
                                    Container(
                                      width: 100.w,
                                      height: 12.h,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                                        child: Image.network(
                                          message.signatureData!.fileUrl!,
                                          width: double.infinity,
                                          fit: BoxFit.fitWidth,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                      ),
                                    )
                                  ],
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
      ),
    );
  }
}