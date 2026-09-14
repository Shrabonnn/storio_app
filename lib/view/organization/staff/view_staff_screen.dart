import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/data/model/organization/staff/staff_model.dart';
import 'package:storio_app/viewModel/organization/staff_view_model.dart';
import 'package:storio_app/widget/universal/date_time_formate.dart';
import 'package:storio_app/widget/universal/info_row_widget.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/image_card.dart';

class ViewStaffScreen extends StatefulWidget {
  const ViewStaffScreen({super.key, required this.staff});

  final StaffModel staff;

  @override
  State<ViewStaffScreen> createState() => _ViewStaffScreenState();
}

class _ViewStaffScreenState extends State<ViewStaffScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<StaffViewModel>();
      viewModel.staffDetail = widget.staff;

      if (widget.staff.id != null) {
        viewModel.getStaffDetail(widget.staff.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: Consumer<StaffViewModel>(
        builder: (context, provider, child) {
          final staff = provider.staffDetail ?? widget.staff;

          return CustomScrollView(
            slivers: [
              CustomSliverAppBar(
                title: staff.name ?? "",
                subtitle: staff.role ?? "",
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
                          image: staff.profilePicData?.fileUrl != null
                              ? Image.network(
                            staff.profilePicData!.fileUrl!,
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
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: AppSizes.smallPadding),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomStatusBadge(
                                      title: staff.status?.toUpperCase() ?? "",
                                      size: AppSizes.cardTitle,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final result = await Navigator.pushNamed(
                                              context,
                                              RoutesName.edit_staff,
                                              arguments: {'staff': staff},
                                            );

                                            if (!mounted) return;

                                            if (result == true && staff.id != null) {
                                              context
                                                  .read<StaffViewModel>()
                                                  .getStaffDetail(staff.id!);
                                            }
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
                              ),
                              SizedBox(height: AppSizes.smallGap),
                              CustomCard2(
                                child: Padding(
                                  padding: EdgeInsets.all(AppSizes.contentPadding),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InfoRowWidget(
                                        icon: Icons.email_outlined,
                                        title: "Email",
                                        value: staff.email ?? "",
                                      ),
                                      SizedBox(height: AppSizes.smallGap),
                                      InfoRowWidget(
                                        icon: Icons.phone,
                                        title: "Phone",
                                        value: staff.phone ?? "",
                                      ),
                                      SizedBox(height: AppSizes.smallGap),
                                      InfoRowWidget(
                                        icon: Icons.workspace_premium,
                                        title: "Experience",
                                        value: staff.bio ?? "",
                                        maxline: 3,
                                      ),
                                      SizedBox(height: AppSizes.smallGap),
                                      InfoRowWidget(
                                        icon: Icons.calendar_month_outlined,
                                        title: "Join Date",
                                        value: formatDate(staff.joiningDate),
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