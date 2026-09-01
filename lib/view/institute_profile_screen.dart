import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/model/institure/key_metrics_model.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/app_sizes.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/institute_profile/Institute_overview_screen.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/universal/custom_app_bar.dart';

import '../model/form_field/form_feild_data.dart';
import '../model/institure/infrastructure_Item_model.dart';
import '../utils/app_colors.dart';
import '../utils/theme/theme_ext.dart';
import '../widget/institute_profile/custom_text_dialog.dart';
import '../widget/institute_profile/information_row.dart';
import '../widget/institute_profile/infrastructure_drop_down.dart';
import '../widget/textStyle/text_title_style.dart';
import '../widget/universal/custom_card.dart';

class InstituteProfileScreen extends StatefulWidget {
  const InstituteProfileScreen({super.key});

  @override
  State<InstituteProfileScreen> createState() => _InstituteProfileScreenState();
}

class _InstituteProfileScreenState extends State<InstituteProfileScreen> {
  final TextEditingController aboutInstitutionController =
      TextEditingController();
  String aboutInstitution = "";

  final TextEditingController missionController = TextEditingController();
  String mission = "";

  final TextEditingController visionController = TextEditingController();
  String vision = "";

  // Infrastructure controller
  final infrastructuresLabelController = TextEditingController();
  final infrastructuresValueController = TextEditingController();
  List<InfrastructureItemModel> infrastructures = [];


  // Metrics controller
  final metricsLabelController = TextEditingController();
  final metricsValueController = TextEditingController();
  IconData selectedMetricIcon = Icons.people_alt_outlined;
  List<KeyMetricsModel> keyMertics = [];

  bool isKeyMetricsExpanded = false;
  bool isinfrastructuresExpanded = false;

  bool isEditing = false;
  bool isHovering = false;



  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Institute Profile",
            subtitle: "Manage your institute information",
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextTitleWidget(
                            title: "Visual Identity",
                            size:AppSizes.sectionTitle,
                            color: color.primary,
                          ),
                          CustomButton(
                            height: 4.h,
                            width: 25.w,
                            size: AppSizes.cardSubTitle,
                            text: isEditing ? "Save" : "Edit Profile",
                            onTap: () {
                              if (!isEditing) {
                                setState(() {
                                  isEditing = true;
                                });
                              } else {
                                // Future API Call

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Saved Successfully"),
                                  ),
                                );

                                setState(() {
                                  isEditing = false;
                                });
                              }
                            },
                            backgroundColor: isEditing
                                ? Colors.grey
                                : color.primary,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.smallGap),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, RoutesName.media_manage_details);
                        },
                        child: Container(
                          width: 100.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            'assets/images/institute.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.itemGap),

                // General Information
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextTitleWidget(
                        title: "General Information",
                        size:AppSizes.sectionTitle,
                        color: color.primary,
                      ),
                      const Divider(thickness: .6),

                      InfoRow(
                        icon: Icons.badge_outlined,
                        label: "EIIN",
                        value: "112233",
                      ),
                      const Divider(thickness: .5, height: 1),

                      InfoRow(
                        icon: Icons.miscellaneous_services_outlined,
                        label: "School Code",
                        value: "02356896",
                      ),
                      const Divider(thickness: .5, height: 1),

                      InfoRow(
                        icon: Icons.access_time,
                        label: "Shift",
                        value: "Morning",
                      ),
                      const Divider(thickness: .5, height: 1),

                      InfoRow(
                        icon: Icons.school_outlined,
                        label: "Type",
                        value: "Co-Education",
                      ),
                      const Divider(thickness: .5, height: 1),

                      InfoRow(
                        icon: Icons.location_city_outlined,
                        label: "Division",
                        value: "Dhaka",
                      ),
                      const Divider(thickness: .5, height: 1),

                      InfoRow(
                        icon: Icons.location_on_outlined,
                        label: "District",
                        value: "Dhaka",
                      ),
                      const Divider(thickness: .5, height: 1),

                      InfoRow(
                        icon: Icons.near_me_outlined,
                        label: "Upazilla",
                        value: "Mirpur",
                      ),
                      const Divider(thickness: .5, height: 1),

                      InfoRow(
                        icon: Icons.grid_view_outlined,
                        label: "Ward",
                        value: "14",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.itemGap),

                // key Metrics
                CustomCard(
                  child: InstituteOverviewScreen(
                    title: "key Metrics",
                    showIcon: true,
                    userIcon: isKeyMetricsExpanded ? Icons.remove : Icons.add,
                    onTap: isEditing ? () {
                      setState(() {
                        isKeyMetricsExpanded = !isKeyMetricsExpanded;
                      });
                    } : null,
                    isExpanded: isKeyMetricsExpanded,
                    expandableChild: InfrastructureDropDown(
                      showIconPicker: true,
                      selectedIcon: selectedMetricIcon,

                      onIconSelected: (icon) {
                        setState(() {
                          selectedMetricIcon = icon;
                        });
                      },

                      fields: [
                        FormFieldData(
                          title: "Metric Label",
                          hint: "e.g. Total Students",
                          controller: metricsLabelController,
                        ),
                        FormFieldData(
                          title: "Metric Value",
                          hint: "e.g. 1550",
                          controller: metricsValueController,
                        ),
                      ],

                      onSave: () {
                        setState(() {
                          keyMertics.add(
                            KeyMetricsModel(
                              label: metricsLabelController.text.trim(),
                              value: metricsValueController.text.trim(),
                              iconData: selectedMetricIcon,
                            ),
                          );

                          metricsLabelController.clear();
                          metricsValueController.clear();

                          isKeyMetricsExpanded = false;
                        });
                      },

                    ),

                    child:Row(
                      children: [
                        Container(

                          decoration: BoxDecoration(
                            color: color.cardBackground,
                            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppSizes.smallPadding),
                            child: Icon(keyMertics.isEmpty ? Icons.people_alt_outlined : keyMertics.last.iconData, size:AppSizes.iconLarge),
                          ),
                        ),
                        SizedBox(width: AppSizes.smallGap),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextBodyStyleWidget(

                                  title:  keyMertics.isEmpty
                                      ? "Total Student"
                                      : keyMertics.last.label,
                                  color: Colors.black54,
                                  size:AppSizes.cardTitle,
                                  maxLines: 1,
                                ),
                              ),

                              SizedBox(width: 1.w,),
                              TextBodyStyleWidget(
                                title: keyMertics.isEmpty
                                    ? "1550"
                                    : keyMertics.last.value,
                                color: color.primary,
                                size:AppSizes.cardTitle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                                          ,
                  ),
                ),
                SizedBox(height: AppSizes.itemGap),


                // Infrastructure Data
                CustomCard(
                  child: InstituteOverviewScreen(
                    title: "Infrastructure Data",
                    showIcon: true,
                    userIcon: isinfrastructuresExpanded ? Icons.remove : Icons.add,
                    onTap: isEditing?() {
                      setState(() {
                        isinfrastructuresExpanded = !isinfrastructuresExpanded;
                      });
                    }: null,
                    isExpanded: isinfrastructuresExpanded,
                    expandableChild: InfrastructureDropDown(

                      fields: [
                        FormFieldData(
                          title: "Infrastructures Level",
                          hint: "e.g. Classrooms",
                          controller: infrastructuresLabelController,
                        ),
                        FormFieldData(
                          title: "Value",
                          hint: "e.g. 20",
                          controller: infrastructuresValueController,
                        ),
                      ],

                      onSave: () {
                        setState(() {
                          infrastructures.add(
                            InfrastructureItemModel(
                              label: infrastructuresLabelController.text.trim(),
                              value: infrastructuresValueController.text.trim(),
                            ),
                          );

                          infrastructuresLabelController.clear();
                          infrastructuresValueController.clear();

                          isKeyMetricsExpanded = false;
                        });
                      },

                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              infrastructures.isEmpty
                                  ? TextBodyStyleWidget(title: "No Data Added",size:AppSizes.cardTitle,)
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextBodyStyleWidget(
                                          title:
                                              "${infrastructures.last.label}",size:AppSizes.cardTitle,color: Colors.black54,
                                        ),
                                        SizedBox(height: AppSizes.appbarGap,),
                                        TextBodyStyleWidget(
                                          title:
                                              "${infrastructures.last.value}",size:AppSizes.cardTitle,color: color.primary,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.itemGap),


                // About Institute
                CustomCard(
                  child: InstituteOverviewScreen(
                    title: "About Institution",
                    isExpanded: false,
                    child: TextField(
                      controller: aboutInstitutionController,
                      readOnly: !isEditing,
                      minLines: 1,
                      maxLines: 6,
                      onChanged: (value) {
                        setState(() {
                          aboutInstitution = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Write something...",
                        isCollapsed: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSizes.itemGap),
                // Mission
                CustomCard(
                  child: InstituteOverviewScreen(
                    title: "Mission",
                    isExpanded: false,
                    child: TextField(
                      controller: missionController,
                      readOnly: !isEditing,
                      minLines: 1,
                      maxLines: 6,
                      onChanged: (value) {
                        setState(() {
                          mission = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Our Mission State...",
                        isCollapsed: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSizes.itemGap),
                CustomCard(
                  child: InstituteOverviewScreen(
                    title: "Vision",
                    isExpanded: false,
                    child: TextField(
                      controller: visionController,
                      readOnly: !isEditing,
                      minLines: 1,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: "Our Vision Statement...",
                        isCollapsed: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),


                SizedBox(height: 9.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }


}
