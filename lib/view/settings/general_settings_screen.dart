import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../data/model/settings/general_settings_model.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/setting/general_setting_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  // ===== Controllers (API-connected fields) =====
  final TextEditingController siteTitleController = TextEditingController();
  final TextEditingController siteTagLineController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController mailingAddressController = TextEditingController();
  final TextEditingController socialMediaLinkController = TextEditingController();

  // ===== Controllers (NOT in API yet — local only) =====
  final TextEditingController seoTitleController = TextEditingController();
  final TextEditingController seoDescriptionController = TextEditingController();
  final TextEditingController seoKeywordsController = TextEditingController();
  final TextEditingController defaultLanguageController = TextEditingController();


  // ===== Image states (API-connected: logo, favicon, dashboard logo, OG image) =====
  int? selectedLogoId;
  String? selectedLogoUrl;

  int? selectedFaviconId;
  String? selectedFaviconUrl;

  int? selectedDashboardLogoId;
  String? selectedDashboardLogoUrl;

  int? selectedOgImageId;
  String? selectedOgImageUrl;

  // ===== Dropdown / toggle states (API-connected) =====
  bool isShowWebsiteName = true;
  bool isShowTagLineName = true;
  bool isSameLogoForDashboard = true;

  // logo_background_color — API lowercase value ("white"/"black"/"transparent") নেয়, UI-তে Capitalized দেখাই
  final List<String> logoOptionList = ["Transparent", "White", "Black"];
  String selectedLogoOption = "Transparent";

  List<String> defaultLanguageList = ["English", "Bangla"];
  String selecteDdefaultLanguage = "English";

  String? _langCodeFromLabel(String label) => label == "Bangla" ? "bn" : "en";
  String _langLabelFromCode(String? code) => code == "bn" ? "Bangla" : "English";

  String selectedStatus = "Coming Soon";
  bool isSearchEnginesToIndexThisSite = true;

  // ===== Social link form state =====
  String selecteSocialMediaLabel = "Selected Platform";
  String? selecteSocialMediaValue; // API-তে এটাই পাঠানো হবে

  bool isEditMode = false;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    final vm = context.read<GeneralSettingViewModel>();

    await vm.fetchManagementSettings();
    await vm.fetchPlatformChoices();

    if (!mounted) return;
    _populateFromModel(vm.generalSetting);

    setState(() => _isInitialLoading = false);
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  void _populateFromModel(GeneralSettingModel? model) {
    if (model == null) return;
    setState(() {
      siteTitleController.text = model.siteTitle ?? '';
      siteTagLineController.text = model.siteTagline ?? '';

      selectedLogoId = model.logo;
      selectedLogoUrl = model.logoUrl;
      selectedFaviconId = model.favicon;
      selectedFaviconUrl = model.faviconUrl;
      selectedDashboardLogoId = model.dashboardLogo;
      selectedDashboardLogoUrl = model.dashboardLogoUrl;
      selectedOgImageId = model.ogImage;
      selectedOgImageUrl = model.ogImageUrl;

      isShowWebsiteName = model.showSiteTitle ?? true;
      isShowTagLineName = model.showSiteTagline ?? true;
      isSameLogoForDashboard = model.useSameLogoForDashboard ?? true;

      final bgColor = model.logoBackgroundColor;
      if (bgColor != null) {
        final capitalized = _capitalize(bgColor);
        selectedLogoOption = logoOptionList.contains(capitalized) ? capitalized : "Transparent";
      }

      contactEmailController.text = model.contactEmail ?? '';
      phoneNumberController.text = model.phoneNumber ?? '';
      mailingAddressController.text = model.mailingAddress ?? '';

      // ===== নতুন: SEO =====
      seoTitleController.text = model.seoTitle ?? '';
      seoDescriptionController.text = model.seoDescription ?? '';
      seoKeywordsController.text = model.seoKeywords ?? '';
      isSearchEnginesToIndexThisSite = model.allowIndexing ?? true;
      selecteDdefaultLanguage = _langLabelFromCode(model.defaultLanguage);
    });
  }

  // ===== Image Picker: Logo =====
  Future<void> _pickLogo() async {
    if (!isEditMode) return;
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {'currentId': selectedLogoId, 'currentFileUrl': selectedLogoUrl},
    );
    if (!mounted) return;
    if (result is Map<String, dynamic>) {
      setState(() {
        selectedLogoId = result['id'] as int?;
        selectedLogoUrl = result['file'] as String?;
      });
    }
  }

  // ===== Image Picker: Favicon =====
  Future<void> _pickFavicon() async {
    if (!isEditMode) return;
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {'currentId': selectedFaviconId, 'currentFileUrl': selectedFaviconUrl},
    );
    if (!mounted) return;
    if (result is Map<String, dynamic>) {
      setState(() {
        selectedFaviconId = result['id'] as int?;
        selectedFaviconUrl = result['file'] as String?;
      });
    }
  }

  // ===== Image Picker: Dashboard Logo =====
  Future<void> _pickDashboardLogo() async {
    if (!isEditMode) return;
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {'currentId': selectedDashboardLogoId, 'currentFileUrl': selectedDashboardLogoUrl},
    );
    if (!mounted) return;
    if (result is Map<String, dynamic>) {
      setState(() {
        selectedDashboardLogoId = result['id'] as int?;
        selectedDashboardLogoUrl = result['file'] as String?;
      });
    }
  }

  // ===== Image Picker: OG Image =====
  Future<void> _pickOgImage() async {
    if (!isEditMode) return;
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {'currentId': selectedOgImageId, 'currentFileUrl': selectedOgImageUrl},
    );
    if (!mounted) return;
    if (result is Map<String, dynamic>) {
      setState(() {
        selectedOgImageId = result['id'] as int?;
        selectedOgImageUrl = result['file'] as String?;
      });
    }
  }

  // ===== Add Social Media Link (API-connected) =====
  Future<void> _addSocialLink() async {
    if (!isEditMode) return;

    if (selecteSocialMediaLabel == "Selected Platform" || selecteSocialMediaValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a platform")),
      );
      return;
    }

    final url = socialMediaLinkController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a link URL")),
      );
      return;
    }

    final vm = context.read<GeneralSettingViewModel>();
    final ok = await vm.addSocialLink(platform: selecteSocialMediaValue!, url: url);

    if (!mounted) return;

    if (ok) {
      socialMediaLinkController.clear();
      setState(() {
        selecteSocialMediaLabel = "Selected Platform";
        selecteSocialMediaValue = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? "Failed to add link")),
      );
    }
  }

  // ===== Remove Social Media Link (API-connected) =====
  Future<void> _removeSocialLink(int id) async {
    if (!isEditMode) return;
    final vm = context.read<GeneralSettingViewModel>();
    final ok = await vm.deleteSocialLink(id);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? "Failed to delete link")),
      );
    }
  }

  // ===== Save all settings =====
  Future<void> _handleSave() async {
    final vm = context.read<GeneralSettingViewModel>();

    final ok = await vm.updateGeneralSettings(
      siteTitle: siteTitleController.text.trim(),
      siteTagline: siteTagLineController.text.trim(),
      logo: selectedLogoId,
      favicon: selectedFaviconId,
      dashboardLogo: isSameLogoForDashboard ? null : selectedDashboardLogoId,
      ogImage: selectedOgImageId,
      useSameLogoForDashboard: isSameLogoForDashboard,
      logoBackgroundColor: selectedLogoOption.toLowerCase(),
      showSiteTitle: isShowWebsiteName,
      showSiteTagline: isShowTagLineName,
      contactEmail: contactEmailController.text.trim(),
      phoneNumber: phoneNumberController.text.trim(),
      mailingAddress: mailingAddressController.text.trim(),
      // ===== নতুন =====
      seoTitle: seoTitleController.text.trim(),
      seoDescription: seoDescriptionController.text.trim(),
      seoKeywords: seoKeywordsController.text.trim(),
      allowIndexing: isSearchEnginesToIndexThisSite,
      defaultLanguage: _langCodeFromLabel(selecteDdefaultLanguage),
    );

    if (!mounted) return;
    setState(() => isEditMode = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? "Settings Saved Successfully" : (vm.errorMessage ?? "Update failed"))),
    );
  }

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

    if (_isInitialLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(
            title: "General Settings",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // Edit mode Banner
                    CustomCard(
                      child: Row(
                        children: [
                          Flexible(
                            child: CustomCard2(
                              child: Row(
                                children: [
                                  Icon(
                                    isEditMode ? Icons.lock_open : Icons.lock_outline,
                                    color: color.primary,
                                  ),
                                  SizedBox(width: AppSizes.appbarGap),
                                  Flexible(
                                    child: TextBodyStyleWidget(
                                      title: isEditMode
                                          ? "Edit mode is active — you can now make changes."
                                          : "This page is in view-only mode — fields are locked. Tap Edit above to make changes.",
                                      maxLines: 3,
                                      size: AppSizes.cardSubTitle,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: AppSizes.itemGap),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditMode = !isEditMode;
                              });
                              if (!isEditMode) {
                                _populateFromModel(
                                  context.read<GeneralSettingViewModel>().generalSetting,
                                );
                              }
                            },
                            child: Container(
                              height: 3.5.h,
                              width: 8.5.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: color.lightVersionOfPrimaryLightVersion),
                                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                                color: color.primary,
                              ),
                              child: Icon(
                                isEditMode ? Icons.close : Icons.edit,
                                color: color.screenBackground,
                                size: AppSizes.icon,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // Site identity
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Site Identity",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Divider(color: color.lightVersionOfPrimaryLightVersion, height: 1),
                          SizedBox(height: AppSizes.appbarGap),

                          TextBodyStyleWidget(
                            title: "Site Title",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. Head International School",
                            enable: isEditMode,
                            controller: siteTitleController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(
                            title: "Site Tagline",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            enable: isEditMode,
                            hintText: "e.g. English Medium",
                            controller: siteTagLineController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // NOT in API yet — local only
                          TextBodyStyleWidget(
                            title: "Default Language",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomDropdown(
                            items: defaultLanguageList,
                            initialValue: selecteDdefaultLanguage,
                            height: 5.h,
                            width: 100.w,
                            enabled: isEditMode,
                            onChanged: (value) {
                              setState(() {
                                selecteDdefaultLanguage = value.toString();
                              });
                            },
                          ),
                          SizedBox(height: AppSizes.smallGap),

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
                                    }
                                        : null,
                                  ),
                                  const TextBodyStyleWidget(title: "Show Website Name"),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: isShowTagLineName,
                                    onChanged: isEditMode
                                        ? (value) {
                                      setState(() {
                                        isShowTagLineName = value ?? false;
                                      });
                                    }
                                        : null,
                                  ),
                                  const TextBodyStyleWidget(title: "Show Tagline"),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // Logo and Favicon
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Logo & Favicon",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Divider(color: color.lightVersionOfPrimaryLightVersion, height: 1),
                          SizedBox(height: AppSizes.appbarGap),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Site Logo
                              Column(
                                children: [
                                  TextBodyStyleWidget(
                                    title: "Site Logo (Public Site)",
                                    color: color.primary,
                                    size: AppSizes.cardTitle,
                                  ),
                                  SizedBox(height: AppSizes.appbarGap),
                                  Container(
                                    width: 25.w,
                                    height: 25.w,
                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                    clipBehavior: Clip.antiAlias,
                                    child: selectedLogoUrl != null && selectedLogoUrl!.isNotEmpty
                                        ? Image.network(
                                      selectedLogoUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.asset('assets/images/person.png', fit: BoxFit.cover),
                                    )
                                        : Image.asset('assets/images/person.png', fit: BoxFit.cover),
                                  ),
                                  SizedBox(height: AppSizes.smallGap),
                                  CustomButton(
                                    height: 4.h,
                                    width: 25.w,
                                    text: "Upload New",
                                    onTap: isEditMode ? _pickLogo : null,
                                  )
                                ],
                              ),
                              SizedBox(width: AppSizes.sectionGap),

                              // Favicon
                              Column(
                                children: [
                                  TextBodyStyleWidget(
                                    title: "Favicon",
                                    color: color.primary,
                                    size: AppSizes.cardTitle,
                                  ),
                                  SizedBox(height: AppSizes.appbarGap),
                                  Container(
                                    width: 25.w,
                                    height: 25.w,
                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                    clipBehavior: Clip.antiAlias,
                                    child: selectedFaviconUrl != null && selectedFaviconUrl!.isNotEmpty
                                        ? Image.network(
                                      selectedFaviconUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.asset('assets/images/person.png', fit: BoxFit.cover),
                                    )
                                        : Image.asset('assets/images/person.png', fit: BoxFit.cover),
                                  ),
                                  SizedBox(height: AppSizes.smallGap),
                                  CustomButton(
                                    height: 4.h,
                                    width: 25.w,
                                    text: "Upload New",
                                    onTap: isEditMode ? _pickFavicon : null,
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Dashboard Logo Options (API-connected)
                          TextBodyStyleWidget(
                            title: "Dashboard Logo Options",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Divider(color: color.lightVersionOfPrimaryLightVersion, height: 1),
                          SizedBox(height: AppSizes.appbarGap),
                          TextBodyStyleWidget(
                            title: "Navbar Logo Background Color",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomDropdown(
                            items: logoOptionList,
                            initialValue: selectedLogoOption,
                            height: 5.h,
                            width: 100.w,
                            enabled: isEditMode,
                            onChanged: (value) {
                              setState(() {
                                selectedLogoOption = value.toString();
                              });
                            },
                          ),
                          SizedBox(height: AppSizes.smallGap),
                          const TextBodyStyleWidget(
                            title: "Choose the background color just for the logo in the dashboard navbar.",
                            fontbold: false,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: isSameLogoForDashboard,
                                onChanged: isEditMode
                                    ? (value) {
                                  setState(() {
                                    isSameLogoForDashboard = value ?? false;
                                  });
                                }
                                    : null,
                              ),
                              const TextBodyStyleWidget(title: "Use Same Logo for Dashboard"),
                            ],
                          ),

                          // "Use Same Logo" আনচেক করলেই আলাদা dashboard logo picker দেখানো হবে
                          if (!isSameLogoForDashboard) ...[
                            SizedBox(height: AppSizes.itemGap),
                            TextBodyStyleWidget(
                              title: "Dashboard Logo",
                              color: color.primary,
                              size: AppSizes.cardTitle,
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            Row(
                              children: [
                                Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                  clipBehavior: Clip.antiAlias,
                                  child: selectedDashboardLogoUrl != null && selectedDashboardLogoUrl!.isNotEmpty
                                      ? Image.network(
                                    selectedDashboardLogoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Image.asset('assets/images/person.png', fit: BoxFit.cover),
                                  )
                                      : Image.asset('assets/images/person.png', fit: BoxFit.cover),
                                ),
                                SizedBox(width: AppSizes.smallGap),
                                CustomButton(
                                  height: 4.h,
                                  width: 25.w,
                                  text: "Upload New",
                                  onTap: isEditMode ? _pickDashboardLogo : null,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // SEO & Social Media (SEO part NOT in API yet, OG Image IS API-connected now)
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(
                            title: "SEO & Social Media",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Divider(color: color.lightVersionOfPrimaryLightVersion, height: 1),
                          SizedBox(height: AppSizes.appbarGap),

                          TextBodyStyleWidget(
                            title: "SEO Title",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            enable: isEditMode,
                            hintText: "e.g. contact@gmail.com",
                            controller: seoTitleController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(
                            title: "SEO Description",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          TextBodyStyleWidget(
                            title: "SEO Keywords",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            enable: isEditMode,
                            hintText: "e.g. school, education, dhaka",
                            controller: seoKeywordsController,
                          ),
                          SizedBox(height: AppSizes.smallGap),
                          const TextBodyStyleWidget(
                            title: "Separate keywords with commas.",
                            fontbold: false,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          CustomTextFieldWidget(
                            enable: isEditMode,
                            hintText: "",
                            controller: seoDescriptionController,
                            minLines: 3,
                            maxLines: 4,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          const TextBodyStyleWidget(
                            title: "Separate keywords with commas.",
                            fontbold: false,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: isSearchEnginesToIndexThisSite,
                                onChanged: isEditMode
                                    ? (value) {
                                  setState(() {
                                    isSearchEnginesToIndexThisSite = value ?? false;
                                  });
                                }
                                    : null,
                              ),
                              const TextBodyStyleWidget(title: "Allow Search Engines to Index this Site"),
                            ],
                          ),
                          Divider(color: color.lightVersionOfPrimaryLightVersion, height: 1),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(
                            title: "Social Share Image (Open Graph)",
                            size: AppSizes.sectionTitle,
                            color: color.primary,
                          ),
                          SizedBox(height: AppSizes.itemGap),
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
                                child: selectedOgImageUrl != null && selectedOgImageUrl!.isNotEmpty
                                    ? Image.network(
                                  selectedOgImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset('assets/images/institute.png', fit: BoxFit.cover),
                                )
                                    : Image.asset('assets/images/institute.png', fit: BoxFit.cover),
                              ),
                              SizedBox(width: AppSizes.smallGap),
                              Expanded(
                                child: Column(
                                  children: [
                                    const TextBodyStyleWidget(
                                      title:
                                      "This image will be displayed when your site link is shared on social media (Facebook, Twitter, LinkedIn). Recommended size: 1200x630px.",
                                      fontbold: false,
                                      maxLines: 8,
                                    ),
                                    SizedBox(height: AppSizes.smallGap),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: CustomButton(
                                            text: "Change",
                                            onTap: isEditMode ? _pickOgImage : null,
                                          ),
                                        ),
                                        SizedBox(width: AppSizes.smallGap),
                                        Flexible(
                                          child: CustomButton(
                                            text: "Remove",
                                            onTap: isEditMode
                                                ? () {
                                              setState(() {
                                                selectedOgImageId = null;
                                                selectedOgImageUrl = null;
                                              });
                                            }
                                                : null,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // Contact Information
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Contact Information",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Divider(color: color.lightVersionOfPrimaryLightVersion, height: 1),
                          SizedBox(height: AppSizes.appbarGap),

                          TextBodyStyleWidget(
                            title: "Contact Email",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            enable: isEditMode,
                            hintText: "e.g. contact@gmail.com",
                            controller: contactEmailController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(
                            title: "Phone Number",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            enable: isEditMode,
                            hintText: "01XXXXXXXXX",
                            controller: phoneNumberController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(
                            title: "Mailing Address",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            enable: isEditMode,
                            hintText: "Main Road, Plot-19, Block-A,Section-11, Mirpur,Dhaka-1216",
                            controller: mailingAddressController,
                            minLines: 3,
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // Dynamic Social Media Links Section (API-connected)
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextBodyStyleWidget(
                                title: "Social Media Links",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),
                              GestureDetector(
                                onTap: isEditMode ? _addSocialLink : null,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isEditMode ? color.primary : color.lightVersionOfPrimaryLightVersion,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: AppSizes.iconLarge,
                                    color: isEditMode ? color.screenBackground : Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: AppSizes.smallGap),

                          // Platform dropdown — API থেকে আসা choices
                          Consumer<GeneralSettingViewModel>(
                            builder: (context, vm, _) {
                              final items = [
                                "Selected Platform",
                                ...vm.platformChoices.map((e) => e.label ?? e.value ?? ""),
                              ];
                              final safeValue = items.contains(selecteSocialMediaLabel)
                                  ? selecteSocialMediaLabel
                                  : "Selected Platform";

                              return CustomDropdown(
                                items: items,
                                initialValue: safeValue,
                                height: 5.h,
                                width: 100.w,
                                enabled: isEditMode,
                                onChanged: (value) {
                                  setState(() {
                                    selecteSocialMediaLabel = value.toString();

                                    if (value == "Selected Platform") {
                                      selecteSocialMediaValue = null;
                                    } else {
                                      final match = vm.platformChoices.firstWhere(
                                            (e) => (e.label ?? e.value ?? "") == value,
                                        orElse: () => PlatformChoiceData(),
                                      );
                                      selecteSocialMediaValue = match.value;
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          CustomTextFieldWidget(
                            enable: isEditMode,
                            hintText: "e.g. https://www.facebook.com/",
                            controller: socialMediaLinkController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          Divider(color: color.lightVersionOfPrimaryLightVersion, height: 1),
                          SizedBox(height: AppSizes.itemGap),

                          // Social links list — সরাসরি ViewModel state থেকে
                          Consumer<GeneralSettingViewModel>(
                            builder: (context, vm, _) {
                              if (vm.isLoading && vm.socialLinks.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }

                              if (vm.socialLinks.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextBodyStyleWidget(
                                    title: "No social links added yet.",
                                    fontbold: false,
                                  ),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: vm.socialLinks.length,
                                itemBuilder: (context, index) {
                                  final item = vm.socialLinks[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: CustomCard2(
                                      child: Row(
                                        children: [
                                          Icon(Icons.link, color: color.primary, size: AppSizes.icon),
                                          SizedBox(width: AppSizes.appbarGap),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextBodyStyleWidget(
                                                  title: item.platform ?? "",
                                                  color: color.primary,
                                                  size: AppSizes.cardTitle,
                                                ),
                                                TextBodyStyleWidget(
                                                  title: item.url ?? "",
                                                  fontbold: false,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (isEditMode)
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                                              onPressed: item.id != null ? () => _removeSocialLink(item.id!) : null,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // Site Status (NOT in API yet — local only)
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Site Status",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Divider(color: color.lightVersionOfPrimaryLightVersion, height: 1),
                          SizedBox(height: AppSizes.appbarGap),
                          Material(
                            color: Colors.transparent,
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(vertical: -4),
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
                              title: TextBodyStyleWidget(title: "Live", color: color.primary),
                              subtitle: const TextBodyStyleWidget(
                                title: "Your site is visible to everyone.",
                                fontbold: false,
                              ),
                              activeColor: Colors.blue,
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(vertical: -4),
                              dense: true,
                              value: "Maintenance",
                              groupValue: selectedStatus,
                              onChanged: isEditMode
                                  ? (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              }
                                  : null,
                              title: TextBodyStyleWidget(title: "Maintenance", color: color.primary),
                              subtitle: const TextBodyStyleWidget(
                                title: "Visitors will see a maintenance page.",
                                fontbold: false,
                              ),
                              activeColor: Colors.blue,
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(vertical: -4),
                              dense: true,
                              value: "Coming Soon",
                              groupValue: selectedStatus,
                              onChanged: isEditMode
                                  ? (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              }
                                  : null,
                              title: TextBodyStyleWidget(title: "Coming Soon", color: color.primary),
                              subtitle: const TextBodyStyleWidget(
                                title: "Visitors will see a \"coming soon\" teaser page.",
                                fontbold: false,
                              ),
                              activeColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // Cancel & Save Buttons
                    if (isEditMode)
                      Consumer<GeneralSettingViewModel>(
                        builder: (context, vm, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                text: "Cancel",
                                onTap: vm.isLoading
                                    ? null
                                    : () {
                                  setState(() => isEditMode = false);
                                  _populateFromModel(vm.generalSetting);
                                },
                                width: 30.w,
                                backgroundColor: color.cardBackground,
                                foregroundColor: color.primary,
                              ),
                              SizedBox(width: AppSizes.appbarGap),
                              Flexible(
                                child: CustomButton(
                                  text: vm.isLoading ? "Saving..." : "Save",
                                  onTap: vm.isLoading ? null : _handleSave,
                                ),
                              ),
                            ],
                          );
                        },
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