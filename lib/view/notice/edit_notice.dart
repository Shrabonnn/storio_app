import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/data/model/Content/notice/notice_model.dart';
import 'package:storio_app/utils/snackbar_message.dart';
import 'package:storio_app/viewModel/Content/notice_view_model.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';


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
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/date_time_formate.dart';

class EditNotice extends StatefulWidget {
  const EditNotice({super.key, required this.notice});
  final NoticeModel notice;

  @override
  State<EditNotice> createState() => _EditNoticeState();
}

class _EditNoticeState extends State<EditNotice> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController publishDateController = TextEditingController();
  final TextEditingController publishTimeController = TextEditingController();


  String? selectedStatusValue;

  bool isShowPdf = false;

  String noticeContent = "";

  bool isSaving = false;


  String? selectedImageUrl;

  int? selectedAttachmentId;

  Future<void> _openContentDetails() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.content_details,
      arguments: {
        "content": noticeContent,
      },
    );

    if (!mounted) return;

    if (result is String) {
      setState(() {
        noticeContent = result;
      });
    }
  }

  Future<void> _openMediaManage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": selectedAttachmentId,
        "currentFileUrl": selectedImageUrl,
      },
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedAttachmentId = result['id'] as int?;
        selectedImageUrl = result['file'] as String?;
      });
    }
  }

  Future<void> _handleUpdateNotice() async {
    if (titleController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context,"Please enter notice title");
      return;
    }

    if (noticeContent.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context,"Please enter notice content");
      return;
    }

    if (selectedStatusValue == null ||
        selectedStatusValue!.isEmpty) {
      SnackBarMessage.showSnackBar(context,"Please select notice status");
      return;
    }

    if (widget.notice.id == null) {
      SnackBarMessage.showSnackBar(context, "Notice ID not found");
      return;
    }

    final viewModel = context.read<NoticeViewModel>();

    setState(() {
      isSaving = true;
    });

    DateTime? publishDate;

    if (publishDateController.text.trim().isNotEmpty) {
      final parsedDate = DateFormat('dd MMM yyyy').parse(publishDateController.text.trim());

      if (publishTimeController.text.trim().isNotEmpty) {
        final parsedTime = DateFormat('hh:mm a').parse(publishTimeController.text.trim());
        publishDate = DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          parsedTime.hour,
          parsedTime.minute,
        );
      } else {
        publishDate = parsedDate;
      }
    }

    final success = await viewModel.updateNoticeApi(
      id: widget.notice.id!,
      title: titleController.text.trim(),
      content: noticeContent.trim(),
      status: selectedStatusValue!,
      publishDate: publishDate,
      attachments: selectedAttachmentId != null
          ? [selectedAttachmentId!]
          : [],
      pdfViewMode: isShowPdf,
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      SnackBarMessage.showSnackBar(context, "Notice updated successfully");

      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(context, viewModel.errorMessage ?? "Failed to update notice");
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    publishTimeController.dispose();
    publishDateController.dispose();
  }

  @override
  void initState() {
    super.initState();

    titleController.text = widget.notice.title ?? '';

    noticeContent = widget.notice.content ?? '';

    publishDateController.text = formatDate(widget.notice.publishDate);
    publishTimeController.text = formatTime(widget.notice.publishDate);

    selectedStatusValue = widget.notice.status;

    isShowPdf = widget.notice.pdfViewMode ?? false;

    // Existing attachment ID
    if (widget.notice.attachments != null &&
        widget.notice.attachments!.isNotEmpty) {
      selectedAttachmentId = widget.notice.attachments!.first;
    }

    // Existing image URL
    if (widget.notice.attachmentsDetail != null &&
        widget.notice.attachmentsDetail!.isNotEmpty) {
      selectedImageUrl =
          widget.notice.attachmentsDetail!.first.file;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<NoticeViewModel>().getStatusChoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(

      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:"Edit Notice",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [



                        // Title
                        TextBodyStyleWidget(title: "Title", color: color.textPrimary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Notice Title", controller: titleController),

                      ],


                    )),
                    SizedBox(height: AppSizes.sectionGap,),

                    // Content
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          TextBodyStyleWidget(
                            title: "Content",
                            color: color.textPrimary,
                            size: AppSizes.sectionTitle,
                          ),

                          SizedBox(height: AppSizes.appbarGap),

                          Column(
                            children: [

                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.smallPadding,
                                    vertical: 8,
                                  ),
                                  child: Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [

                                      editorOption("paragraph"),
                                      editorOption("Default"),
                                      editorOption("14px"),

                                      editorIcon("B"),
                                      editorIcon("I"),
                                      editorIcon("U"),
                                      editorIcon("S"),

                                      const Text(
                                        "x²",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      SizedBox(width: 6),

                                      Container(
                                        width: 1,
                                        height: 25,
                                        color: Colors.grey.shade300,
                                      ),



                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSizes.appbarGap,),



                              Divider(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),

                              SizedBox(height: AppSizes.appbarGap,),
                              // Small preview area
                              GestureDetector(
                                onTap: _openContentDetails,
                                child: Padding(
                                  padding: EdgeInsets.all(AppSizes.smallPadding),
                                  child: TextBodyStyleWidget(
                                    title: noticeContent.isEmpty ? "Write content here..." : noticeContent,
                                    size: AppSizes.cardTitle,),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),


                    SizedBox(height: AppSizes.sectionGap,),

                    // Status
                    CustomCard(
                      child: Consumer<NoticeViewModel>(
                        builder: (context, provider, child) {
                          if (provider.statusLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (provider.statusChoices.isEmpty) {
                            return TextBodyStyleWidget(
                              title: "No status available",
                              color: color.primary,
                            );
                          }

                          final statusChoices = provider.statusChoices
                              .where((item) => item.value != "binned")
                              .toList();

                          final statusItems = statusChoices
                              .map((item) => item.label)
                              .toList();

                          String? selectedLabel;

                          for (final item in statusChoices) {
                            if (item.value == selectedStatusValue) {
                              selectedLabel = item.label;
                              break;
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBodyStyleWidget(
                                title: "Status",
                                color: color.textPrimary,
                                size: AppSizes.sectionTitle,
                              ),

                              SizedBox(height: AppSizes.appbarGap),

                              CustomDropdown(
                                items: statusItems,
                                initialValue: selectedLabel ?? statusItems.first,
                                width: 100.w,

                                onChanged: (value) {
                                  final selectedChoice = statusChoices.firstWhere(
                                        (item) => item.label == value,
                                  );

                                  setState(() {
                                    selectedStatusValue = selectedChoice.value;

                                    if (selectedChoice.value != "schedule") {
                                      publishTimeController.clear();
                                    }
                                  });

                                  debugPrint(
                                    "Selected status: ${selectedChoice.value}",
                                  );
                                },
                              ),

                              SizedBox(height: AppSizes.itemGap),

                              if (selectedStatusValue == "draft" ||
                                  selectedStatusValue == "published" ||
                                  selectedStatusValue == "archived")
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextBodyStyleWidget(
                                      title: "Publish Date",
                                      color: color.textPrimary,
                                      size: AppSizes.sectionTitle,
                                    ),

                                    SizedBox(height: AppSizes.appbarGap),

                                    CustomTextFieldWidget(
                                      hintText: "yyyy-mm-dd",
                                      controller: publishDateController,
                                      isDatePicker: true,
                                    ),
                                  ],
                                )
                              else if (selectedStatusValue == "schedule")
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextBodyStyleWidget(
                                            title: "Publish Date",
                                            color: color.textPrimary,
                                            size: AppSizes.sectionTitle,
                                          ),

                                          SizedBox(height: AppSizes.appbarGap),

                                          CustomTextFieldWidget(
                                            hintText: "yyyy-mm-dd",
                                            controller: publishDateController,
                                            isDatePicker: true,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: AppSizes.smallGap),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextBodyStyleWidget(
                                            title: "Time",
                                            color: color.textPrimary,
                                            size: AppSizes.sectionTitle,
                                          ),

                                          SizedBox(height: AppSizes.appbarGap),

                                          CustomTextFieldWidget(
                                            hintText: "2:30 PM",
                                            controller: publishTimeController,
                                            isTimePicker: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap,),


                    CustomCard(child: Row(
                      children: [
                        Checkbox(
                          value: isShowPdf,
                          onChanged: (value) {
                            setState(() {
                              isShowPdf = value ?? false;
                            });
                          },
                        ),
                        SizedBox(width: AppSizes.itemGap,),

                        Expanded(
                          child: TextBodyStyleWidget(
                            title:  "Show PDF in view mode ( embed PDF viewer on public page instead of showing only a download button )",fontbold: false,maxLines: 3,
                          ),
                        ),
                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),



                    // Images
                    CustomCard(child:  Column(
                      crossAxisAlignment: .center,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            TextBodyStyleWidget(title: "Featured Image", color: color.textPrimary,size: AppSizes.sectionTitle,),
                            SizedBox(width: AppSizes.appbarGap),
                            CustomButton(
                              height: 4.h,
                              width: 30.w,
                              text:  "Change Image",
                              onTap: _openMediaManage,
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap),

                         Container(
                          width: 100.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child:  _buildFeaturedImage(),
                        )

                      ],


                    ),),






                    SizedBox(height: AppSizes.sectionGap,),


                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                        SizedBox(width: AppSizes.smallGap,),
                        Flexible(
                          child: CustomButton(
                            text: isSaving ? "Updating..." : "Update Post",
                            onTap: isSaving? null :_handleUpdateNotice,
                          ),
                        ),
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
  Widget _buildFeaturedImage() {
    if (selectedImageUrl != null && selectedImageUrl!.isNotEmpty) {
      return Image.network(
        selectedImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/institute.png',
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      'assets/images/institute.png',
      fit: BoxFit.cover,
    );
  }
}