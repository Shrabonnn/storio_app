import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/sizes.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/institute_profile/Institute_overview_screen.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_app_bar.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../widget/universal/custom_drop_down.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final List<String> statusList = [
    "All Status",
    "New",
    "Read",
    "Replied",
    "Archived",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Contact Management", showBackButton: true),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 4.5.h,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search Conversation",
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        CustomDropdown(
                          items: statusList,
                          initialValue: "All Status",
                          width: 32.w,
                          height: 4.5.h,
                          onChanged: (value) {
                            print("Selected: $value");
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    CustomCard(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: .center,
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              TextTitleWidget(
                                title: "Inbox",
                                color: AppColors.primary,
                              ),
                              CustomButton(
                                text: "2 messages",
                                onTap: () {},
                                height: 4.h,
                                width: 30.w,
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, index) {

                              // Temporary data
                              // Later these values will come from API
                              final String name = "Maiyasha";
                              final String subject = "Re admission";
                              final String message = "no message";
                              final String status = "new";

                              final String? time = "2:18 PM";
                              final String date = "June 22";

                              final bool isNew = status.toLowerCase() == "new";

                              return Container(
                                margin: EdgeInsets.only(
                                  bottom: AppSizes.itemGap,
                                ),
                                padding: EdgeInsets.all(
                                  AppSizes.smallPadding,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.cardRadius,
                                  ),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),

                                child: Row(
                                  children: [

                                    // Avatar
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor: isNew
                                          ? AppColors.primary
                                          : Colors.grey.shade400,
                                      child: Text(
                                        name.isNotEmpty
                                            ? name[0].toUpperCase()
                                            : "?",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: AppSizes.cardTitle,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: AppSizes.smallGap),

                                    // Message information
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: AppSizes.cardTitle,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          const SizedBox(height: 2),

                                          Text(
                                            subject,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: AppSizes.cardSubTitle,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),

                                          Text(
                                            message,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: AppSizes.cardSubTitle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: AppSizes.smallGap),

                                    // Right side
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [

                                        // Time if available, otherwise date
                                        Text(
                                          time != null && time.isNotEmpty
                                              ? time
                                              : date,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: AppSizes.cardSubTitle,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        // Status for EVERY message
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: AppSizes.smallPadding,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isNew
                                                ? AppColors.primary
                                                : Colors.grey.shade300,
                                            borderRadius:
                                            BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                              color: isNew
                                                  ? Colors.white
                                                  : AppColors.primary,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(width: 4),

                                    // Arrow
                                     InkWell(
                                       onTap: (){
                                         Navigator.pushNamed(context, RoutesName.contact_message_details);
                                       },
                                       child: Icon(
                                        Icons.chevron_right,
                                        size: AppSizes.icon,
                                        color: Colors.grey,
                                                                           ),
                                     ),
                                  ],
                                ),
                              );
                            },
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
