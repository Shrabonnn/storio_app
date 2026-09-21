import 'dart:convert';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/info_item_card.dart';

import '../../data/model/Content/admission/admission_model.dart';
import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../viewModel/Content/admission_view_model.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/date_time_formate.dart';

class ViewAdmissionScreen extends StatefulWidget {
  const ViewAdmissionScreen({
    super.key,
    this.application,
  });

  final AdmissionApplicationModel? application;

  @override
  State<ViewAdmissionScreen> createState() => _ViewAdmissionScreenState();
}

class _ViewAdmissionScreenState extends State<ViewAdmissionScreen> {
  AdmissionApplicationModel? appData;
  bool isDownloading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (appData == null) {
      if (widget.application != null) {
        appData = widget.application;
      } else {
        final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args != null && args.containsKey('application')) {
          appData = args['application'] as AdmissionApplicationModel;
        }
      }
    }
  }

  // Generic Status Update Helper using confirmAction
  Future<void> _handleStatusUpdate({
    required String newStatus,
    required String actionTitle,
    required String confirmMessage,
  }) async {
    if (appData?.id == null) return;

    final confirmed = await confirmAction(
      context,
      title: actionTitle,
      message: confirmMessage,
    );

    if (!confirmed || !mounted) return;

    final viewModel = context.read<AdmissionViewModel>();
    final success = await viewModel.updateApplicationStatus(
      appData!.id!,
      status: newStatus,
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        appData!.status = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Application status updated to $newStatus")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? "Failed to update status"),
        ),
      );
    }
  }

  // ============================================================
  // Download THIS application's data
  // ============================================================
  //
  // NOTE: the backend only exposes a bulk "export all applications"
  // CSV endpoint (see AdmissionViewModel.exportApplicationsCsv,
  // GET /api/admission/applications/export_csv/) — there's no
  // single-application export endpoint documented. So instead of
  // hitting the API, this builds a small CSV for just this
  // application from the data already loaded in `appData` and hands
  // it to the OS share sheet (Save to Files / email / WhatsApp /
  // etc.), entirely on-device.
  Future<void> _handleDownload() async {
    if (appData == null) return;

    setState(() => isDownloading = true);

    try {
      final csvContent = _buildCsvForApplication(appData!);
      final Uint8List bytes = Uint8List.fromList(utf8.encode(csvContent));
      final safeName =
      (appData!.applicationNumber ?? "application_${appData!.id}")
          .replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');

      // saveAs opens the native "Save As" dialog so the user picks
      // exactly where to put the file (e.g. Downloads) — no share
      // sheet, no Quick Share, no security PIN prompt.
      await FileSaver.instance.saveAs(
        name: safeName,
        bytes: bytes,
        ext: "csv",
        mimeType: MimeType.csv,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Application data saved")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to export application data: $e")),
      );
    } finally {
      if (mounted) setState(() => isDownloading = false);
    }
  }

  String _buildCsvForApplication(AdmissionApplicationModel app) {
    String escape(String value) => '"${value.replaceAll('"', '""')}"';

    final buffer = StringBuffer();
    buffer.writeln('Field,Value');
    buffer.writeln(
      '${escape("Application Number")},${escape(app.applicationNumber ?? '')}',
    );
    buffer.writeln('${escape("Status")},${escape(app.status ?? '')}');
    buffer.writeln(
      '${escape("Submitted At")},${escape(app.submittedAt?.toIso8601String() ?? '')}',
    );

    if (app.formData != null) {
      for (final entry in app.formData!.entries) {
        buffer.writeln(
          '${escape(entry.key)},${escape(entry.value?.toString() ?? '')}',
        );
      }
    }

    if (app.reviewerNotes != null && app.reviewerNotes!.isNotEmpty) {
      buffer.writeln(
        '${escape("Reviewer Notes")},${escape(app.reviewerNotes!)}',
      );
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    if (appData == null) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            const CustomSliverAppBar(
              title: "Application Details",
              showBackButton: true,
            ),
            SliverFillRemaining(
              child: Center(
                child: TextBodyStyleWidget(title: "No application data found"),
              ),
            ),
          ],
        ),
      );
    }

    final app = appData!;
    final studentName =
    (app.formData?['student_name'] ?? app.formData?['full_name'] ?? "N/A").toString();
    final grade = (app.formData?['applied_class'] ??
        app.formData?['grade'] ??
        "N/A")
        .toString();
    final email = (app.formData?['email'] ?? "N/A").toString();
    final phone = (app.formData?['phone'] ?? "N/A").toString();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "${studentName ?? ''}",
            subtitle: app.applicationNumber,
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =================================================
                      // 1. STUDENT NAME & GRADE
                      // =================================================
                      Row(
                        children: [
                          Expanded(
                            child: InfoItemCard(
                              title: "Student Name",
                              name: studentName,
                              icons: Icons.person,
                            ),
                          ),
                          SizedBox(width: AppSizes.smallGap),
                          Expanded(
                            child: InfoItemCard(
                              title: "Grade / Class",
                              name: grade,
                              icons: Icons.school_outlined,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.smallGap),

                      // =================================================
                      // 2. EMAIL & PHONE
                      // =================================================
                      Row(
                        children: [
                          Expanded(
                            child: InfoItemCard(
                              title: "Email",
                              name: email,
                              icons: Icons.email_outlined,
                            ),
                          ),
                          SizedBox(width: AppSizes.smallGap),
                          Expanded(
                            child: InfoItemCard(
                              title: "Phone",
                              name: phone,
                              icons: Icons.phone_outlined,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.smallGap),

                      // =================================================
                      // 3. SUBMITTED DATE & STATUS
                      // =================================================
                      Row(
                        children: [
                          Expanded(
                            child: InfoItemCard(
                              title: "Submitted Date",
                              name: app.submittedAt != null
                                  ? formatDate(app.submittedAt!)
                                  : "N/A",
                              icons: Icons.calendar_month_outlined,
                            ),
                          ),
                          SizedBox(width: AppSizes.smallGap),
                          Expanded(
                            child: InfoItemCard(
                              title: "Status",
                              name: app.status?.toUpperCase() ?? "PENDING",
                              icons: Icons.star,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.smallGap),

                      // =================================================
                      // 4. ACTION BUTTONS CARD (Approve, Reject, Review, Pending, Download)
                      // =================================================
                      CustomCard2(
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.contentPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextTitleWidget(
                                title: "Actions",
                                color: color.primary,
                                size: AppSizes.screenTitle,
                              ),
                              SizedBox(height: AppSizes.smallGap),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Approve
                                  IconButton(
                                    tooltip: "Approve",
                                    onPressed: () => _handleStatusUpdate(
                                      newStatus: "approved",
                                      actionTitle: "Approve Application",
                                      confirmMessage:
                                      "Are you sure you want to approve this application?",
                                    ),
                                    icon: Icon(
                                      Icons.check_circle_outline,
                                      size: AppSizes.iconLarge,
                                      color: Colors.green,
                                    ),
                                  ),

                                  // Reject
                                  IconButton(
                                    tooltip: "Reject",
                                    onPressed: () => _handleStatusUpdate(
                                      newStatus: "rejected",
                                      actionTitle: "Reject Application",
                                      confirmMessage:
                                      "Are you sure you want to reject this application?",
                                    ),
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      size: AppSizes.iconLarge,
                                      color: Colors.redAccent,
                                    ),
                                  ),

                                  // Under Review
                                  IconButton(
                                    tooltip: "Move to Under Review",
                                    onPressed: () => _handleStatusUpdate(
                                      newStatus: "under_review",
                                      actionTitle: "Move to Under Review",
                                      confirmMessage:
                                      "Are you sure you want to mark this application as Under Review?",
                                    ),
                                    icon: Icon(
                                      Icons.visibility_outlined,
                                      size: AppSizes.iconLarge,
                                      color: Colors.orange,
                                    ),
                                  ),

                                  // Reset to Pending
                                  IconButton(
                                    tooltip: "Reset to Pending",
                                    onPressed: () => _handleStatusUpdate(
                                      newStatus: "pending",
                                      actionTitle: "Reset to Pending",
                                      confirmMessage:
                                      "Are you sure you want to reset this application status to Pending?",
                                    ),
                                    icon: Icon(
                                      Icons.access_time,
                                      size: AppSizes.iconLarge,
                                      color: color.primary,
                                    ),
                                  ),

                                  // Download this application's data
                                  IconButton(
                                    tooltip: "Download Data",
                                    onPressed: isDownloading ? null : _handleDownload,
                                    icon: isDownloading
                                        ? SizedBox(
                                      width: AppSizes.iconLarge,
                                      height: AppSizes.iconLarge,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: color.primary,
                                      ),
                                    )
                                        : Icon(
                                      Icons.download_outlined,
                                      size: AppSizes.iconLarge,
                                      color: color.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: AppSizes.smallGap),

                      // =================================================
                      // 5. SUBMITTED FORM DETAILS
                      // =================================================
                      CustomCard2(
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.contentPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextTitleWidget(
                                title: "Submitted Form Data",
                                color: color.primary,
                                size: AppSizes.screenTitle,
                              ),
                              SizedBox(height: AppSizes.smallGap),

                              if (app.formData != null &&
                                  app.formData!.isNotEmpty)
                                ...app.formData!.entries.map((entry) {
                                  final formattedKey = entry.key
                                      .replaceAll('_', ' ')
                                      .toUpperCase();
                                  return Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 45.w,
                                            child: TextBodyStyleWidget(
                                              title: formattedKey,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextBodyStyleWidget(
                                              title: entry.value?.toString() ??
                                                  "N/A",
                                              color: color.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: color.lightVersionOfPrimaryLightVersion,
                                      )
                                    ],
                                  );
                                }),

                              if (app.reviewerNotes != null &&
                                  app.reviewerNotes!.isNotEmpty) ...[
                                SizedBox(height: AppSizes.smallGap),
                                TextTitleWidget(
                                  title: "Reviewer Notes",
                                  color: color.primary,
                                  size: AppSizes.cardTitle,
                                ),
                                SizedBox(height: AppSizes.smallGap),
                                TextBodyStyleWidget(
                                  title: app.reviewerNotes!,
                                  color: color.primary,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      // =================================================
                      // 6. ATTACHED DOCUMENTS (If available)
                      // =================================================
                      if (app.files != null && app.files!.isNotEmpty) ...[
                        SizedBox(height: AppSizes.smallGap),
                        CustomCard2(
                          child: Padding(
                            padding: EdgeInsets.all(AppSizes.contentPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextTitleWidget(
                                  title: "Submitted Documents",
                                  color: color.primary,
                                  size: AppSizes.screenTitle,
                                ),
                                SizedBox(height: AppSizes.smallGap),
                                ...app.files!.map((fileItem) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.insert_drive_file_outlined,
                                          color: color.primary,
                                        ),
                                        SizedBox(width: AppSizes.smallGap),
                                        Expanded(
                                          child: TextBodyStyleWidget(
                                            title: fileItem.fieldId ??
                                                "Attachment",
                                          ),
                                        ),
                                        Icon(
                                          Icons.open_in_new,
                                          size: AppSizes.icon,
                                          color: color.primary,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}