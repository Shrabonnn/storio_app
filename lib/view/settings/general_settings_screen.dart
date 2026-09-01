import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';
import 'package:storio_app/widget/universal/image_circle_widget.dart';

import '../../model/activity/activity_details_seo_settings_model.dart';
import '../../model/form_field/form_feild_data.dart';
import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/institute_profile/Institute_overview_screen.dart';
import '../../widget/institute_profile/infrastructure_drop_down.dart';
import '../../widget/quill/editor_icon.dart';
import '../../widget/quill/editor_option.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_text_field.dart';


class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {

  final TextEditingController siteTitleController = TextEditingController();
  final TextEditingController siteTagLineController = TextEditingController();
  final TextEditingController defaultLanguageController = TextEditingController();


  final TextEditingController seoTitleController = TextEditingController();
  final TextEditingController seoDescriptionController = TextEditingController();
  final TextEditingController seoKeywordsController = TextEditingController();

  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController mailingAddressController = TextEditingController();

  final TextEditingController socialMediaLinkController = TextEditingController();


  List<String> logoOptionList = ["Transparent", "White" , "Black"];
  String selectedLogoOption = "Transparent";

  List<String> defaultLanguageList = ["English","Bangla" ];
  String selecteDdefaultLanguage = "English";

  final List<String> socialMediaList = [
    "Selected Platform",
    "Facebook",
    "Instagram",
    "X (Twitter)",
    "TikTok",
    "YouTube",
    "LinkedIn",
    "Snapchat",
    "Pinterest",
    "Reddit",
    "Threads",
  ];
  String selecteSocialMedia = "Selected Platform";


  String selectedStatus = "Coming Soon";

  bool isShowWebsiteName = true;
  bool isShowTagLineName = true;
  bool isSameLogoForDashboard = true;
  bool isSearchEnginesToIndexThisSite = true;

  bool isEditMode  = false;
  @override
  void dispose() {
    siteTitleController.dispose();
    siteTagLineController.dispose();
    defaultLanguageController.dispose();

    seoTitleController.dispose();
    seoDescriptionController.dispose();
    seoKeywordsController.dispose();

    contactEmailController.dispose();
    phoneNumberController.dispose();
    mailingAddressController.dispose();

    socialMediaLinkController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:"General Settings",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [

                    // Edit option
                    CustomCard(child: Row(
                      children: [
                        Flexible(
                          child: CustomCard2(child: Row(
                            children: [
                              Icon(isEditMode ? Icons.lock_open : Icons.lock_outline ,color: color.primary,),

                              SizedBox(width: AppSizes.appbarGap,),
                              Flexible(child: TextBodyStyleWidget(
                                title: isEditMode
                                    ? "Edit mode is active — you can now make changes."
                                    : "This page is in view-only mode — fields are locked. Tap Edit above to make changes.",
                                maxLines: 3,size: AppSizes.cardSubTitle,
                              ),)

                            ],
                          )),
                        ),
                        SizedBox(width: AppSizes.itemGap,),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              isEditMode = !isEditMode;
                            });
                          },
                          child: Container(
                            height: 3.5.h,
                            width: 8.5.w,
                            decoration: BoxDecoration(
                                border: Border.all(color: color.lightVersionOfPrimaryLightVersion),
                                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                                color: color.primary
                            ),child: Icon(Icons.edit,color: color.screenBackground,size: AppSizes.icon,),),
                        )
                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),

                    // Site identitty
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        TextBodyStyleWidget(title: "Site Identity", color: color.primary,size: AppSizes.sectionTitle,),
                        Divider(),

                        // Title
                        TextBodyStyleWidget(title: "Site Title", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Head Internation School",enable: isEditMode, controller: siteTitleController),
                        SizedBox(height: AppSizes.itemGap,),

                        // Tagline
                        TextBodyStyleWidget(title: "Site Tagline", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(enable: isEditMode,hintText: "e.g. English Medium", controller: siteTagLineController),
                        SizedBox(height: AppSizes.itemGap,),

                        // Title
                        TextBodyStyleWidget(title: "Default Language", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomDropdown(
                          items: defaultLanguageList,
                          initialValue: selecteDdefaultLanguage,
                          height: 5.h,
                          width: 100.w,
                          enabled: isEditMode,
                          onChanged:  (value) {
                            setState(() {
                              selecteDdefaultLanguage = value.toString();
                            });
                          }
                        ),
                        SizedBox(height: AppSizes.smallGap,),


                        Wrap(
                          spacing: 15,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: isShowWebsiteName,
                                  onChanged: isEditMode
                                      ? (value) {
                                    setState(() {
                                      isShowWebsiteName = value ?? false;
                                    });
                                  }:null,
                                ),
                                const TextBodyStyleWidget(
                                  title: "Show Website Name",
                                ),
                              ],
                            ),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: isShowTagLineName,
                                  onChanged: isEditMode
                                      ?(value) {
                                    setState(() {
                                      isShowTagLineName = value ?? false;
                                    });
                                  }: null,
                                ),
                                const TextBodyStyleWidget(
                                  title: "Show Tagline",
                                ),
                              ],
                            ),
                          ],
                        )
                      ],


                    )),
                    SizedBox(height: AppSizes.sectionGap,),



                    // Logo and Favicon
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        TextBodyStyleWidget(title: "Logo & Favicon", color: color.primary,size: AppSizes.sectionTitle,),
                        Divider(),
                        Row(
                          mainAxisAlignment: .spaceEvenly,
                          children: [
                            Column(
                              children: [
                                TextBodyStyleWidget(title: "Site Logo (Public Site)", color: color.primary,size: AppSizes.cardTitle,),
                                SizedBox(height: AppSizes.appbarGap,),
                                ImageCircleWidget(imgPath: "assets/images/person.png"),
                                SizedBox(height: AppSizes.smallGap,),
                                CustomButton(height:4.h,width: 25.w,text: "Upload New", onTap: (){
                                  isEditMode ? Navigator.pushNamed(context, RoutesName.media_manage_details):null;
                                })
                              ],
                            ),
                            SizedBox(width: AppSizes.sectionGap,),
                            Column(
                              children: [
                                TextBodyStyleWidget(title: "Favicon", color: color.primary,size: AppSizes.cardTitle,),
                                SizedBox(height: AppSizes.appbarGap,),
                                ImageCircleWidget(imgPath: "assets/images/person.png"),
                                SizedBox(height: AppSizes.smallGap,),
                                CustomButton(height: 4.h,width: 25.w,text: "Upload New", onTap: (){
                                  isEditMode ? Navigator.pushNamed(context, RoutesName.media_manage_details):null;
                                })
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap,),

                        // Dashboard Logo option
                        TextBodyStyleWidget(title: "Dashboard Logo Options", color: color.primary,size: AppSizes.sectionTitle,),
                        Divider(),
                        TextBodyStyleWidget(title: "Navbar Logo Background Color", color: color.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomDropdown(
                          items: logoOptionList,
                          initialValue: selectedLogoOption,
                          height: 5.h,
                          width: 100.w,
                          enabled: isEditMode,

                          onChanged: (value) {
                            print("Selected: $value");
                            setState(() {
                              selectedLogoOption = value.toString();
                            });


                          },
                        ),
                        SizedBox(height: AppSizes.smallGap,),
                        TextBodyStyleWidget(title: "Choose the background color just for the logo in the dashboard navbar.",fontbold: false,),
                        SizedBox(height: AppSizes.itemGap,),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: isSameLogoForDashboard,
                              onChanged:isEditMode
                                  ? (value) {
                                setState(() {
                                  isSameLogoForDashboard = value ?? false;
                                });
                              }: null,
                            ),
                            const TextBodyStyleWidget(
                              title: "Use Same Logo for Dashboard",
                            ),
                          ],
                        ),





                      ],
                    )),

                    SizedBox(height: AppSizes.sectionGap,),


                    // SEO & Social Media
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        TextBodyStyleWidget(title: "SEO & Social Media", color: color.primary,size: AppSizes.sectionTitle,),
                        Divider(),

                        // Title
                        TextBodyStyleWidget(title: "SEO Title", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(enable: isEditMode,hintText: "e.g. contact@gmail.com", controller: seoTitleController),
                        SizedBox(height: AppSizes.itemGap,),


                        // Title
                        TextBodyStyleWidget(title: "SEO Description", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(enable: isEditMode,hintText: "", controller: seoDescriptionController,minLines: 3,maxLines: 4,),

                        SizedBox(height: AppSizes.itemGap,),
                        TextBodyStyleWidget(title: "Separate keywords with commas.",fontbold: false,),
                        SizedBox(height: AppSizes.itemGap,),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: isSearchEnginesToIndexThisSite,
                              onChanged:isEditMode
                                  ? (value) {
                                setState(() {
                                  isSearchEnginesToIndexThisSite = value ?? false;
                                });
                              }: null,
                            ),
                            const TextBodyStyleWidget(
                              title: "Allow Search Engines to Index this Site",
                            ),
                          ],
                        ),
                        Divider(),

                        TextBodyStyleWidget(title: "Social Share Image (Open Graph)",size: AppSizes.sectionTitle,color: color.primary,),
                        SizedBox(height: AppSizes.itemGap,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 45.w,
                              height: 19.5.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                'assets/images/institute.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: AppSizes.smallGap),
                            Expanded(
                              child: Column(
                                children: [
                                  TextBodyStyleWidget(title: "This image will be displayed when your site link is shared on social media (Facebook, Twitter, LinkedIn). Recommended size: 1200x630px.",fontbold: false,maxLines: 8,),
                                  SizedBox(height: AppSizes.smallGap,),
                                  Row(
                                    children: [
                                      Flexible(child: CustomButton(text: "Change", onTap: (){})),
                                      SizedBox(width: AppSizes.smallGap,),
                                      Flexible(child: CustomButton(text: "Remove", onTap: (){})),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        )

                      ],


                    )),
                    SizedBox(height: AppSizes.sectionGap,),


                    // Contact Information
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        TextBodyStyleWidget(title: "Contact Information", color: color.primary,size: AppSizes.sectionTitle,),
                        Divider(),

                        // Title
                        TextBodyStyleWidget(title: "Contact Email", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(enable: isEditMode,hintText: "e.g. contact@gmail.com", controller: contactEmailController),
                        SizedBox(height: AppSizes.itemGap,),

                        // Tagline
                        TextBodyStyleWidget(title: "Phone Number", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(enable: isEditMode,hintText: "01XXXXXXXXX", controller: phoneNumberController),
                        SizedBox(height: AppSizes.itemGap,),

                        // Title
                        TextBodyStyleWidget(title: "Mailing Address", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(enable: isEditMode,hintText: "Main Road, Plot-19, Block-A,Section-11, Mirpur,Dhaka-1216", controller: mailingAddressController,minLines: 3,maxLines: 4,),

                      ],


                    )),
                    SizedBox(height: AppSizes.sectionGap,),


                    // Social Media Link
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            TextBodyStyleWidget(title: "Social Media Links", color: color.primary,size: AppSizes.sectionTitle),
                            
                            GestureDetector(onTap: (){

                            },child: Icon(Icons.add,color: color.primary,size: AppSizes.iconLarge,fontWeight: FontWeight.bold,))
                          ],
                        ),
                        Divider(),

                        CustomDropdown(
                          items: socialMediaList,
                          initialValue: selecteSocialMedia,
                          height: 5.h,
                          width: 100.w,
                          enabled: isEditMode,
                          onChanged: (value) {
                            print("Selected: $value");
                            setState(() {
                              selecteSocialMedia = value.toString();
                            });


                          },
                        ),
                        SizedBox(height: AppSizes.itemGap,),
                        CustomTextFieldWidget(enable: isEditMode,hintText: "e.g. https://www.facebook.com/", controller: socialMediaLinkController),

                      ],


                    )),
                    SizedBox(height: AppSizes.sectionGap,),

                    // Site Status
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          TextBodyStyleWidget(title: "Site Status", color: color.primary,size: AppSizes.sectionTitle,),

                          Divider(),

                          Material(
                            color: Colors.transparent,
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                vertical: -4,
                              ),
                              dense: true,
                              value: "Live",
                              groupValue: selectedStatus,
                              onChanged: isEditMode
                                  ? (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              }
                                  : null,
                              title: TextBodyStyleWidget(title: "Live",color: color.primary,),
                              subtitle: TextBodyStyleWidget(title: "Your site is visible to everyone.",fontbold: false,),
                              activeColor: Colors.blue,
                            ),
                          ),

                          Material(
                            color: Colors.transparent,
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                vertical: -4,
                              ),
                              dense: true,
                              value: "Maintenance",
                              groupValue: selectedStatus,
                              onChanged:  isEditMode
                                  ? (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              }
                                  : null,
                              title: TextBodyStyleWidget(title: "Maintenance",color: color.primary,),
                              subtitle:TextBodyStyleWidget(title: "Visitors will see a maintenance page.",fontbold: false,),
                              activeColor: Colors.blue,
                            ),
                          ),

                          Material(
                            color: Colors.transparent,
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                vertical: -4,
                              ),
                              dense: true,
                              value: "Coming Soon",
                              groupValue: selectedStatus,
                              onChanged:  isEditMode
                                  ? (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              }
                                  : null,
                              title:TextBodyStyleWidget(title: "Coming Soon",color: color.primary,),
                              subtitle: TextBodyStyleWidget(title: "Visitors will see a \"coming soon\" teaser page.",fontbold: false,),
                              activeColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap,),






                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text:"Save", onTap: (){},)),
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
