import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';
import 'package:storio_app/widget/universal/status_button_row.dart';

import '../../data/model/Content/video_reel/reel_model.dart';
import '../../res/api_url/app_url.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../viewModel/Content/reel_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_text_field.dart';

class AddNewVideo extends StatefulWidget {
  const AddNewVideo({super.key, this.isEdit = false, this.reel});

  final bool isEdit;
  final ReelModel? reel;

  @override
  State<AddNewVideo> createState() => _AddNewVideoState();
}

class _AddNewVideoState extends State<AddNewVideo> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController embedCodeController = TextEditingController();
  final TextEditingController externalLinkCodeController = TextEditingController();

  final List<String> contentType = [
    "Video",
    "Reel",
  ];

  int selectedContentType = 0;

  final List<String> videoSource = [
    "External Link",
    "Upload Video",
    "Embed Code"
  ];

  int selectedVideoSource = 0;

  final List<String> visibilityStatus = [
    "Active",
    "Draft",
    "Archived"
  ];

  int selectedVisibilityStatus = 0;

  final List<String> platformType = [
    "Custom / Native",
    "Youtube",
    "Instagram",
    "TikTok",
    "Vimeo"
  ];

  // label -> API value
  final Map<String, String> platformValueMap = {
    "Custom / Native": "custom",
    "Youtube": "youtube",
    "Instagram": "instagram",
    "TikTok": "tiktok",
    "Vimeo": "vimeo",
  };

  String selectedPlatformType = "Custom / Native";

  bool isfeature = false;

  // Cover image (thumbnail). The API expects a media file PK (int),
  // NOT a raw URL string — selectedThumbnailId is what actually gets
  // sent in the payload. selectedThumbnailUrl is only for display.
  int? selectedThumbnailId;
  String? selectedThumbnailUrl;

  // True once the user has manually picked a cover image from Media
  // Library, or an edit was prefilled — stops the YouTube
  // auto-detect from overwriting a deliberate choice.
  bool _thumbnailManuallySet = false;

  // YouTube auto-cover detection
  String? _lastProcessedYoutubeId;
  bool isFetchingYoutubeThumbnail = false;

  // Video file, picked from Media Library (only used when
  // selectedVideoSource == 1 "Upload Video")
  String? selectedVideoFileUrl;

  bool isSaving = false;
  bool isDetailLoading = false;

  @override
  void initState() {
    super.initState();

    externalLinkCodeController.addListener(_onVideoUrlChanged);

    if (widget.reel != null) {
      _prefillFromModel(widget.reel!);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      if (widget.isEdit && widget.reel?.id != null) {
        setState(() {
          isDetailLoading = true;
        });

        final viewModel = context.read<ReelViewModel>();
        await viewModel.getReelDetail(widget.reel!.id!);

        if (!mounted) return;

        setState(() {
          isDetailLoading = false;
        });

        if (viewModel.reelDetail != null) {
          _prefillFromModel(viewModel.reelDetail!);
        }
      }
    });
  }

  // ============================================================
  // Prefill Fields From Model
  // ============================================================

  void _prefillFromModel(ReelModel reel) {
    titleController.text = reel.title ?? '';
    descriptionController.text = reel.description ?? '';

    // contentType = ["Video", "Reel"] -> index 0 / 1
    selectedContentType = (reel.type == "reel") ? 1 : 0;

    // platform value -> label
    selectedPlatformType = platformValueMap.entries
        .firstWhere(
          (e) => e.value == reel.platform,
      orElse: () => const MapEntry("Custom / Native", "custom"),
    )
        .key;

    // API only returns active / draft — "Archived" has no backend
    // equivalent yet, so anything other than "active" maps to Draft.
    selectedVisibilityStatus = (reel.status == "active") ? 0 : 1;

    // Existing thumbnail is display-only here (GET responses only
    // give back a URL, not the PK) — we intentionally do NOT set
    // selectedThumbnailId, so unless the user picks a new cover
    // image, "thumbnail" is simply left out of the update payload
    // and the backend keeps the existing one untouched.
    selectedThumbnailUrl = reel.thumbnail;
    _thumbnailManuallySet = true;

    // Backend only stores a single `url` field (no separate
    // upload/embed distinction), so on edit we always show it under
    // "External Link" pre-filled with the saved url.
    selectedVideoSource = 0;
    externalLinkCodeController.text = reel.url ?? '';

    // Prevent the listener from re-triggering an auto-fetch for a
    // URL that's already saved.
    _lastProcessedYoutubeId = _extractYoutubeId(reel.url ?? '');

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    externalLinkCodeController.removeListener(_onVideoUrlChanged);
    titleController.dispose();
    descriptionController.dispose();
    embedCodeController.dispose();
    externalLinkCodeController.dispose();
    super.dispose();
  }

  // ============================================================
  // YouTube Auto-Cover Detection
  // ============================================================

  String? _extractYoutubeId(String url) {
    if (url.trim().isEmpty) return null;

    final patterns = [
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/shorts/([a-zA-Z0-9_-]{11})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null) return match.group(1);
    }
    return null;
  }

  void _onVideoUrlChanged() {
    if (selectedVideoSource != 0) return;

    final url = externalLinkCodeController.text.trim();
    final videoId = _extractYoutubeId(url);

    if (videoId == null) return; // not a YouTube link, leave as-is
    if (videoId == _lastProcessedYoutubeId) return; // already handled

    _lastProcessedYoutubeId = videoId;

    // Auto-select platform for convenience
    setState(() {
      selectedPlatformType = "Youtube";
    });

    if (!_thumbnailManuallySet) {
      _fetchAndUploadYoutubeThumbnail(videoId);
    }
  }

  Future<void> _fetchAndUploadYoutubeThumbnail(String videoId) async {
    final previewUrl = "https://img.youtube.com/vi/$videoId/hqdefault.jpg";

    // ১. লিংক পাওয়া মাত্রই সাথে সাথে স্ক্রিনে ইউটিউব থাম্বনেল প্রিভিউ দেখাবে
    setState(() {
      selectedThumbnailUrl = previewUrl;
      isFetchingYoutubeThumbnail = true;
    });

    try {
      final response = await http.get(Uri.parse(previewUrl));
      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        throw Exception("Could not fetch YouTube thumbnail");
      }

      final tempDir = Directory.systemTemp.createTempSync('yt_thumb_');
      final file = File('${tempDir.path}/$videoId.jpg');
      await file.writeAsBytes(response.bodyBytes);

      if (!mounted) return;

      final viewModel = context.read<ReelViewModel>();
      final uploadResult = await viewModel.uploadReelThumbnail(file);

      if (!mounted) return;

      if (uploadResult != null && uploadResult['media_file_id'] != null) {
        final rawUrl = uploadResult['url'] as String?;

        String? fullThumbnailUrl;
        if (rawUrl != null && rawUrl.isNotEmpty) {
          fullThumbnailUrl = rawUrl.startsWith('http')
              ? rawUrl
              : '${AppUrl.baseUrl}$rawUrl';
        }

        setState(() {
          selectedThumbnailId = uploadResult['media_file_id'] as int?;
          selectedThumbnailUrl = fullThumbnailUrl ?? previewUrl;
        });
      }
    } catch (e) {
      debugPrint("YOUTUBE THUMBNAIL FETCH ERROR: $e");
      setState(() {
        selectedThumbnailUrl = previewUrl;
      });
    } finally {
      if (mounted) {
        setState(() {
          isFetchingYoutubeThumbnail = false;
        });
      }
    }
  }

  // ============================================================
  // Pick Cover Image From Media Library
  // ============================================================

  Future<void> _pickCoverImage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": selectedThumbnailId,
        "currentFileUrl": selectedThumbnailUrl,
      },
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedThumbnailId = result['id'] as int?;
        selectedThumbnailUrl = result['file'] as String?;
        _thumbnailManuallySet = true;
      });
    }
  }

  // ============================================================
  // Pick Video File From Media Library
  // ============================================================

  Future<void> _pickVideoFile() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedVideoFileUrl = result['file'] as String?;
      });
    }
  }

  // ============================================================
  // Save / Update Video
  // ============================================================

  Future<void> _handleSaveVideo() async {
    if (titleController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter a title");
      return;
    }

    String? videoUrl;

    if (selectedVideoSource == 0) {
      // External Link
      if (externalLinkCodeController.text.trim().isEmpty) {
        SnackBarMessage.showSnackBar(context, "Please enter a video URL");
        return;
      }

      final uri = Uri.tryParse(externalLinkCodeController.text.trim());
      if (uri == null || !uri.isAbsolute) {
        SnackBarMessage.showSnackBar(context, "Please enter a valid URL");
        return;
      }

      videoUrl = externalLinkCodeController.text.trim();
    } else if (selectedVideoSource == 1) {
      // Upload Video
      if (selectedVideoFileUrl == null || selectedVideoFileUrl!.isEmpty) {
        SnackBarMessage.showSnackBar(
          context,
          "Please select a video from Media Library",
        );
        return;
      }
      videoUrl = selectedVideoFileUrl;
    } else {
      // Embed Code -> not supported by the API yet (it only accepts
      // a video URL, not an iframe snippet)
      SnackBarMessage.showSnackBar(
        context,
        "Embed code isn't supported yet. Please use External Link or Upload Video.",
      );
      return;
    }

    if (widget.isEdit && widget.reel?.id == null) {
      SnackBarMessage.showSnackBar(context, "Video ID not found");
      return;
    }

    if (isFetchingYoutubeThumbnail) {
      SnackBarMessage.showSnackBar(
        context,
        "Still fetching the YouTube cover, please wait a moment",
      );
      return;
    }

    final viewModel = context.read<ReelViewModel>();

    setState(() {
      isSaving = true;
    });

    final Map<String, dynamic> data = {
      "title": titleController.text.trim(),
      "type": selectedContentType == 1 ? "reel" : "video",
      "platform": platformValueMap[selectedPlatformType] ?? "custom",
      "url": videoUrl,
      // "Archived" has no backend equivalent yet -> falls back to draft
      "status": selectedVisibilityStatus == 0 ? "active" : "draft",
    };

    // IMPORTANT: the API expects the media file PK here, not a URL
    // string — sending a URL causes a 400 ("Expected pk value").
    if (selectedThumbnailId != null) {
      data["thumbnail"] = selectedThumbnailId;
    }

    if (descriptionController.text.trim().isNotEmpty) {
      data["description"] = descriptionController.text.trim();
    }

    final success = widget.isEdit
        ? await viewModel.updateReel(widget.reel!.id!, data)
        : await viewModel.createReel(data);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      SnackBarMessage.showSnackBar(
        context,
        widget.isEdit
            ? "Video updated successfully"
            : "Video created successfully",
      );
      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.errorMessage ??
            (widget.isEdit
                ? "Failed to update video"
                : "Failed to create video"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(

      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:widget.isEdit? "Edit Video" :"Create New Video",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Title
                        TextBodyStyleWidget(title: "Title", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "e.g. Enter video title",
                          controller: titleController,
                          onChange: (_) => setState(() {}), // keep Live Preview in sync
                        ),
                        SizedBox(height: AppSizes.itemGap,),


                        // Content Type & Platform
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  TextBodyStyleWidget(title: "Content Type", color: color.primary,size: AppSizes.sectionTitle,),
                                  SizedBox(height: AppSizes.appbarGap,),
                                  StatusButtonRow(items: contentType, selectedIndex: selectedContentType,
                                    onSelected:(index){
                                      setState(() {
                                        selectedContentType = index;
                                      });
                                    },
                                  )

                                ],
                              ),
                            ),
                            SizedBox(width: AppSizes.sectionGap,),
                            SizedBox(width: AppSizes.sectionGap,),
                            SizedBox(width: AppSizes.sectionGap,),
                            Column(
                              children: [

                                TextBodyStyleWidget(title: "Platform", color: color.primary,size: AppSizes.sectionTitle,),
                                SizedBox(height: AppSizes.appbarGap,),
                                CustomDropdown(
                                  items: platformType,
                                  initialValue: selectedPlatformType,
                                  width: 38.w,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPlatformType = value.toString();
                                    });
                                  },
                                )

                              ],
                            )
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap,),


                        // Video sources
                        TextBodyStyleWidget(title: "Video Source", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        StatusButtonRow(items: videoSource, selectedIndex: selectedVideoSource,
                          onSelected:(index){
                            setState(() {
                              selectedVideoSource = index;

                            });
                          },
                        ),
                        if(selectedVideoSource == 0)...[
                          SizedBox(height: AppSizes.itemGap,),
                          CustomTextFieldWidget(controller: externalLinkCodeController, hintText: "https://..."),
                          if (isFetchingYoutubeThumbnail) ...[
                            SizedBox(height: AppSizes.smallGap,),
                            Row(
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: color.primary),
                                ),
                                SizedBox(width: AppSizes.appbarGap,),
                                TextBodyStyleWidget(title: "Fetching YouTube cover...", maxLines: 1,),
                              ],
                            ),
                          ],
                        ],
                        if(selectedVideoSource == 1)...[
                          SizedBox(height: AppSizes.itemGap,),
                          GestureDetector(
                            onTap: _pickVideoFile,
                            child: CustomCard2(child: Padding(
                              padding:  EdgeInsets.all(AppSizes.contentPadding),
                              child: Column(
                                children: [
                                  Icon(
                                    selectedVideoFileUrl != null
                                        ? Icons.check_circle_outline
                                        : Icons.cloud_upload_outlined,
                                    size: AppSizes.appBarIcon,
                                    color: selectedVideoFileUrl != null
                                        ? color.primary
                                        : Colors.grey,
                                  ),
                                  SizedBox(height: AppSizes.itemGap,),
                                  TextBodyStyleWidget(
                                    title: selectedVideoFileUrl != null
                                        ? "Video selected from Media Library"
                                        : "Select video from Media Library",
                                    maxLines: 1,
                                  )
                                ],
                              ),
                            )),
                          )
                        ],
                        if(selectedVideoSource == 2)...[
                          SizedBox(height: AppSizes.itemGap,),
                          CustomTextFieldWidget(controller: embedCodeController, minLines: 3,maxLines:4,hintText: "Paste iframe embed code here ...")
                        ],
                        SizedBox(height: AppSizes.itemGap,),


                        TextBodyStyleWidget(title: "Description", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Enter video description", controller: descriptionController,minLines: 4,maxLines: 6,),

                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),
                    CustomCard(child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.remove_red_eye_outlined,size: AppSizes.iconLarge,color: Colors.grey,),
                            SizedBox(width: AppSizes.appbarGap,),
                            TextBodyStyleWidget(title: "Visibility & Status", color: color.primary,size: AppSizes.sectionTitle,),

                          ],
                        ),
                        SizedBox(height: AppSizes.appbarGap,),
                        StatusButtonRow(items: visibilityStatus, selectedIndex: selectedVisibilityStatus,
                          onSelected: (index){
                            setState(() {
                              selectedVisibilityStatus = index;
                            });
                          },),
                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),
                    CustomCard(child: Row(
                      children: [
                        Checkbox(
                          value: isfeature,
                          onChanged: (value) {
                            setState(() {
                              isfeature = value ?? false;
                            });
                          },
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextTitleWidget(title: "Featured Content",color: color.primary,maxLines: 1,),
                              TextBodyStyleWidget(title: "Display this video in the landing page carousel.",maxLines: 1,)
                            ],
                          ),
                        ),
                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),

                    // Cover image
                    CustomCard(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextTitleWidget(title: "Cover Image",color: color.primary,),
                            if (selectedThumbnailUrl != null && selectedThumbnailUrl!.isNotEmpty)
                              TextButton(
                                onPressed: _pickCoverImage,
                                child: const Text("Change"),
                              ),
                          ],
                        ),
                        SizedBox(height: AppSizes.appbarGap,),
                        GestureDetector(
                          onTap: _pickCoverImage,
                          child: (selectedThumbnailUrl != null && selectedThumbnailUrl!.isNotEmpty)
                              ?Container(
                            width: 100.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              selectedThumbnailUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/institute.png',
                                  fit: BoxFit.fitWidth,
                                );
                              },
                            ),
                          ) : CustomCard2(child: Padding(
                            padding:  EdgeInsets.all(AppSizes.contentPadding),
                            child: Column(
                              children: [
                                Icon(Icons.cloud_upload_outlined,size: AppSizes.appBarIcon,color: Colors.grey,),
                                SizedBox(height: AppSizes.itemGap,),
                                TextBodyStyleWidget(title: "Choose From Media Library",)
                              ],
                            ),
                          )),
                        )

                      ],
                    )),


                    SizedBox(height: AppSizes.sectionGap,),

                    //Live preview
                    CustomCard(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextTitleWidget(title: "Live Preview",color: color.primary,),
                        SizedBox(height: AppSizes.appbarGap,),
                        CustomCard2(child: Padding(
                          padding:  EdgeInsets.all(AppSizes.contentPadding),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                                child: (selectedThumbnailUrl != null && selectedThumbnailUrl!.isNotEmpty)
                                    ? Image.network(
                                  selectedThumbnailUrl!,
                                  width: 28.w,
                                  height: 10.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 28.w,
                                    height: 10.h,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.image_outlined, color: Colors.grey),
                                  ),
                                )
                                    : Container(
                                  width: 28.w,
                                  height: 10.h,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image_outlined, color: Colors.grey),
                                ),
                              ),
                              SizedBox(width: AppSizes.itemGap,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextTitleWidget(
                                      title: titleController.text.trim().isEmpty
                                          ? "Untitled Video"
                                          : titleController.text.trim(),
                                      color: color.primary,
                                      maxLines: 1,
                                    ),
                                    SizedBox(height: AppSizes.appbarGap,),
                                    TextBodyStyleWidget(
                                      title:
                                      "${selectedContentType == 1 ? "Reel" : "Video"} • $selectedPlatformType",
                                      maxLines: 1,
                                    ),
                                    SizedBox(height: AppSizes.smallGap,),
                                    TextBodyStyleWidget(
                                      title: visibilityStatus[selectedVisibilityStatus],
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))

                      ],
                    )),



                    SizedBox(height: AppSizes.sectionGap,),
                    // Save Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){
                          Navigator.pop(context);
                        },width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(
                          text: isSaving
                              ? (widget.isEdit ? "Updating..." : "Saving...")
                              : (widget.isEdit ? "Update Video" : "Save Video"),
                          onTap: isSaving ? (){} : _handleSaveVideo,
                        )),
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