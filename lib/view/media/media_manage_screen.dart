import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/app_sizes.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../viewModel/Media/media_view_model.dart';
import '../../widget/universal/image_card.dart';

class MediaManageScreen extends StatefulWidget {
  const MediaManageScreen({super.key});

  @override
  State<MediaManageScreen> createState() => _MediaManageScreenState();
}

class _MediaManageScreenState extends State<MediaManageScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MediaViewModel>().getMediaList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _openDetails({int? id, String? fileUrl}) async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": id,
        "currentFileUrl": fileUrl,
      },
    );


    if (!mounted) return;
    context.read<MediaViewModel>().getMediaList(
      search: searchController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Media Manage", showBackButton: true),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(
                            controller: searchController,
                            hinText: "Search Media...",
                            onChanged: (value) {
                              context.read<MediaViewModel>().getMediaList(
                                search: value.trim(),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        CustomButton(
                          text: "+ Add New File",
                          width: 30.w,
                          height: 4.5.h,
                          onTap: () => _openDetails(),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.sectionGap),

                Consumer<MediaViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.libraryLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (viewModel.libraryError != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: TextBodyStyleWidget(
                          title: "Failed to load media: ${viewModel.libraryError}",
                          color: Colors.redAccent,
                        ),
                      );
                    }

                    if (viewModel.libraryItems.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: TextBodyStyleWidget(
                          title: "No media found",
                          color: color.primary,
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.libraryItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        final item = viewModel.libraryItems[index];

                        return GestureDetector(
                          onTap: () => _openDetails(
                            id: item.id,
                            fileUrl: item.file,
                          ),
                          child: ImageCard(
                            image: AspectRatio(
                              aspectRatio: 1.3,
                              child: Container(
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                child: (item.fileType == "image" &&
                                    item.file != null &&
                                    item.file!.isNotEmpty)
                                    ? Image.network(
                                  item.file!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    );
                                  },
                                )
                                    : Icon(
                                  _iconForFileType(item.fileType),
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            title: TextBodyStyleWidget(
                              title: (item.title == null || item.title!.isEmpty)
                                  ? (item.fileName ?? "Untitled")
                                  : item.title!,
                              color: Colors.black,
                              size: AppSizes.cardTitle,
                              maxLines: 1,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForFileType(String? type) {
    switch (type) {
      case "document":
        return Icons.description;
      case "video":
        return Icons.videocam;
      case "audio":
        return Icons.audiotrack;
      case "archive":
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }
}