import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_text_field.dart';
import '../../../widget/universal/search_text_field.dart';

class AddNewRole extends StatefulWidget {
  const AddNewRole({super.key,  this.isEdit =false});

  final bool isEdit;

  @override
  State<AddNewRole> createState() => _AddNewRoleState();
}

class _AddNewRoleState extends State<AddNewRole> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();


  final Map<String, List<String>> permissions = {
    "Accounts": [
      "Can add Email OTP",
      "Can add user profile",
      "Can add User Session",
      "Can change Email OTP",
      "Can change user profile",
      "Can change User Session",
      "Can delete Email OTP",
      "Can delete user profile",
    ],
    "Doctors": [
      "Can add Doctor",
      "Can edit Doctor",
      "Can delete Doctor",
      "Can view Doctor",
    ],
    "Appointments": [
      "Can add Appointment",
      "Can edit Appointment",
      "Can delete Appointment",
      "Can view Appointment",
    ],
  };

  final Set<String> selectedPermissions = {};

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    searchController.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:widget.isEdit? "Edit Role Details":"Create New Role",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(child:
                    Column(
                      crossAxisAlignment: .start,
                      children: [

                        // Title
                        TextBodyStyleWidget(title: "Role Name ", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "", controller: nameController),

                      ])),
                    SizedBox(height: AppSizes.sectionGap),
                    // =====================================================
                    // ASSIGNED PERMISSIONS
                    // =====================================================

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              TextBodyStyleWidget(
                                title: "Assigned Permissions",
                                color: AppColors.primary,
                                size: AppSizes.sectionTitle,
                              ),

                               SizedBox(width: AppSizes.smallGap),

                              Text(
                                "(${selectedPermissions.length} selected)",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: AppSizes.appbarGap,
                          ),

                          Container(
                            height: 22.h, // fixed height
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary,
                              ),
                              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                            ),
                            child: selectedPermissions.isEmpty
                                ?  Padding(
                              padding: EdgeInsets.all(AppSizes.contentPadding),
                              child: Text(
                                "No permissions selected.",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            )
                                : ListView.builder(
                              padding:  EdgeInsets.symmetric(vertical:AppSizes.smallPadding),
                              itemCount: selectedPermissions.length,
                              itemBuilder: (context, index) {

                                final permission =
                                selectedPermissions.elementAt(index);

                                return ListTile(
                                  dense: true,
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),

                                  title: TextBodyStyleWidget(title: permission,fontbold: false,size: AppSizes.cardTitle,),

                                  trailing: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedPermissions.remove(
                                          permission,
                                        );
                                      });
                                    },

                                    child: Icon(
                                      Icons.close,
                                      size: AppSizes.icon,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: AppSizes.sectionGap,
                    ),

                   // =====================================================
                     // ASSIGN PERMISSIONS
                    // =====================================================

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          TextBodyStyleWidget(
                            title: "Assign Permissions",
                            color: AppColors.primary,
                            size: AppSizes.sectionTitle,
                          ),

                          SizedBox(
                            height: AppSizes.appbarGap,
                          ),

                          // SEARCH
                          Row(
                            children: [
                              Expanded(
                                child: SearchTextField(hinText: "Serach Permissions...", controller: searchController, onChanged:(value){
                                  setState(() {

                                  });
                                },),
                              ),
                            ],
                          ),


                          SizedBox(
                            height: AppSizes.smallGap,
                          ),

                          // PERMISSION LIST
                          Container(
                            height: 45.h,
                            width: double.infinity,

                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary,
                              ),
                              borderRadius:
                              BorderRadius.circular(AppSizes.buttonRadius),
                            ),

                            child: ListView(
                              padding: EdgeInsets.zero,

                              children: permissions.entries.map(
                                    (entry) {

                                  final category = entry.key;

                                  final permissionList = entry.value;

                                  // SEARCH FILTER
                                  final filteredList =
                                  permissionList.where(
                                        (permission) {

                                      return permission
                                          .toLowerCase()
                                          .contains(
                                        searchController.text
                                            .toLowerCase(),
                                      );
                                    },
                                  ).toList();

                                  if (filteredList.isEmpty) {
                                    return const SizedBox();
                                  }

                                  // CATEGORY SELECTED?
                                  final allSelected =
                                  filteredList.every(
                                        (permission) =>
                                        selectedPermissions
                                            .contains(permission),
                                  );

                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                    children: [

                                      // =====================================
                                      // CATEGORY HEADER
                                      // =====================================

                                      Container(
                                        padding:
                                         EdgeInsets.all(AppSizes.contentPadding
                                        ),

                                        decoration: BoxDecoration(
                                          color: AppColors.cartBackgroundLight,
                                          border: Border(
                                            bottom: BorderSide(
                                              color:AppColors.cartBackgroundLight,
                                            ),
                                          ),
                                        ),

                                        child: Row(
                                          children: [

                                            Expanded(
                                              child: TextTitleWidget(title: category,color: AppColors.primary,),
                                            ),

                                            TextButton(
                                              onPressed: () {

                                                setState(() {

                                                  if (allSelected) {

                                                    // UNSELECT ALL
                                                    for (final permission
                                                    in filteredList) {

                                                      selectedPermissions
                                                          .remove(
                                                        permission,
                                                      );
                                                    }

                                                  } else {

                                                    // SELECT ALL
                                                    selectedPermissions
                                                        .addAll(
                                                      filteredList,
                                                    );
                                                  }
                                                });
                                              },

                                              child: Text(
                                                allSelected
                                                    ? "Unselect All"
                                                    : "Select All",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // =====================================
                                      // PERMISSIONS
                                      // =====================================

                                      ...filteredList.map(
                                            (permission) {

                                          final isSelected =
                                          selectedPermissions
                                              .contains(
                                            permission,
                                          );

                                          return CheckboxListTile(
                                            dense: true,

                                            value: isSelected,

                                            activeColor:
                                            AppColors.primary,

                                            controlAffinity:
                                            ListTileControlAffinity
                                                .leading,

                                            title: TextBodyStyleWidget(title: permission,color: AppColors.primary,fontbold: false,),

                                            onChanged: (_) {

                                              setState(() {

                                                if (isSelected) {

                                                  selectedPermissions
                                                      .remove(
                                                    permission,
                                                  );

                                                } else {

                                                  selectedPermissions.add(
                                                    permission,
                                                  );
                                                }
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap,),



                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: Colors.white,foregroundColor: AppColors.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text:widget.isEdit? "Update Role":"Create Role", onTap: (){},)),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),







                  ],
                )

              ]),
            ),
          ),

        ],
      ),
    );
  }
}
