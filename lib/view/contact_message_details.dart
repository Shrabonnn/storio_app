import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';

import '../utils/app_colors.dart';
import '../utils/sizes.dart';
import '../widget/custom_button/custom_buttom.dart';
import '../widget/universal/custom_app_bar.dart';
import '../widget/universal/custom_card.dart';

class ContactMessageDetails extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String dateTime;
  final String subject;
  final String message;
  final String status;

  final VoidCallback? onNew;
  final VoidCallback? onRead;
  final VoidCallback? onReply;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const ContactMessageDetails({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.dateTime,
    required this.subject,
    required this.message,
    required this.status,
    this.onReply,
    this.onArchive,
    this.onDelete, this.onNew, this.onRead,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNew = status.toLowerCase() == "new";

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Message Details", showBackButton: true),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Status + More
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isNew
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5),
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

                          PopupMenuButton<String>(

                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.grey,
                            ),
                            onSelected: (value) {
                              if (value == "eew") {
                                onNew?.call();
                              }else if (value == "eead") {
                                onRead?.call();
                              }else if (value == "replied") {
                                onReply?.call();
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: "new",
                                child: Text("New"),
                              ),
                              const PopupMenuItem(
                                value: "read",
                                child: Text("Read"),
                              ),
                              const PopupMenuItem(
                                value: "replied",
                                child: Text("Replied"),
                              ),


                            ],
                          ),
                        ],
                      ),

                      // User Information
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              name.isNotEmpty
                                  ? name[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),

                          SizedBox(width: AppSizes.smallGap),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextTitleWidget(title: name,color: AppColors.primary,),

                                SizedBox(height: 2),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        email,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: AppSizes.cardSubTitle,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 2),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      phone,
                                      style: TextStyle(
                                        fontSize: AppSizes.cardSubTitle,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.smallGap),

                      // Date
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 15,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateTime,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: AppSizes.cardSubTitle,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      // Message
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppSizes.smallPadding),
                        decoration: BoxDecoration(
                          color: const Color(0xffF8FAFD),
                          borderRadius: BorderRadius.circular(
                            AppSizes.cardRadius,
                          ),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: AppSizes.cardTitle,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(height: AppSizes.itemGap),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 4,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade500,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),

                                SizedBox(width: AppSizes.appbarGap),

                                Expanded(
                                  child: Text(
                                    message,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: AppSizes.cardSubTitle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      // Submitted On
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppSizes.smallPadding),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppSizes.cardRadius,
                          ),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color: AppColors.primary,
                              size: 22,
                            ),

                            SizedBox(width: AppSizes.smallGap),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Submitted On",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: AppSizes.cardSubTitle,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Text(
                                  dateTime,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: AppSizes.cardSubTitle,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "Reply",
                              onTap: onReply ?? () {},
                              height: 4.5.h,
                            ),
                          ),

                          SizedBox(width: AppSizes.smallGap),

                          Expanded(
                            child: CustomButton(
                              text: "Archived",
                              onTap: onArchive ?? () {},
                              height: 4.5.h,
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              borderSide: BorderSide(
                                color: AppColors.primary,
                              ),
                            ),
                          ),

                          SizedBox(width: AppSizes.smallGap),

                          Expanded(
                            child: CustomButton(
                              text: "Delete",
                              onTap: onDelete ?? () {},
                              height: 4.5.h,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}