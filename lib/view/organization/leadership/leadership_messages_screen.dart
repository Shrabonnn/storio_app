import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/organization/leader_message/leadership_message_model.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/organization/leadership_message_view_model.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/confirm_action.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/image_circle_widget.dart';
import '../../../widget/universal/more_menu.dart';

class LeadershipMessagesScreen extends StatefulWidget {
  const LeadershipMessagesScreen({super.key});

  @override
  State<LeadershipMessagesScreen> createState() =>
      _LeadershipMessagesScreenState();
}

class _LeadershipMessagesScreenState extends State<LeadershipMessagesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshMessages();
    });
  }

  void _refreshMessages() {
    context.read<LeadershipMessageViewModel>().getMessageApi();
  }



  Future<void> _confirmDelete(LeadershipMessageModel message) async {
    if (message.id == null) return;

    final confirmed = await confirmAction(
      context,
      title: "Delete Message",
      message:
      "Are you sure you want to permanently delete this leadership message?",
    );

    if (!confirmed) return;
    if (!mounted) return;

    final viewModel = context.read<LeadershipMessageViewModel>();
    final success = await viewModel.deleteMessage(message.id!);

    if (!mounted) return;

    SnackBarMessage.showSnackBar(
      context,
      success
          ? "Message deleted successfully"
          : (viewModel.errorMessage ?? "Failed to delete message"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshMessages();
        },
        child: CustomScrollView(
          slivers: [
            CustomSliverAppBar(
              title: "Leadership Messages",
              showBackButton: true,
            ),

            Consumer<LeadershipMessageViewModel>(
              builder: (context, provider, child) {
                if (provider.loading) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (provider.errorMessage != null &&
                    provider.messageList.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: TextBodyStyleWidget(
                          title: provider.errorMessage!,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                }

                if (provider.messageList.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: TextBodyStyleWidget(
                          title: "No leadership messages found",
                          color: color.primary,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.only(
                    top: AppSizes.screenPadding,
                    left: AppSizes.screenPadding,
                    right: AppSizes.screenPadding,
                  ),
                  sliver: SliverList.builder(
                    itemCount: provider.messageList.length,
                    itemBuilder: (context, index) {
                      final message = provider.messageList[index];

                      return Container(
                        margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                        child: CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /*Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: color
                                            .lightVersionOfPrimaryLightVersion,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: (message.imageData?.fileUrl !=
                                          null &&
                                          message
                                              .imageData!.fileUrl!.isNotEmpty)
                                          ? Image.network(
                                        message.imageData!.fileUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stack) {
                                          return const Image(
                                            image: AssetImage(
                                              "assets/images/person.png",
                                            ),
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                          : const Image(
                                        image: AssetImage(
                                          "assets/images/person.png",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
*/
                                  ImageCircleWidget(
                                    imgPath: message.imageData?.fileUrl ?? "",
                                    isNetwork: true,
                                  ),
                                  SizedBox(width: AppSizes.smallGap),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        TextTitleWidget(
                                          title: message.name ?? "-",
                                          size: AppSizes.sectionTitle,
                                          color: color.primary,
                                        ),
                                        SizedBox(height: AppSizes.appbarGap),
                                        TextBodyStyleWidget(
                                          title: message.role ?? "-",
                                          size: AppSizes.cardTitle,
                                          color: color.primary,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: AppSizes.itemGap),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      MoreMenu(
                                        items: const [
                                          MoreMenuAction.view,
                                          MoreMenuAction.edit,
                                          MoreMenuAction.delete,
                                        ],
                                        onSelected: (action) async {
                                          switch (action) {
                                            case MoreMenuAction.edit:
                                              final result =
                                              await Navigator.pushNamed(
                                                context,
                                                RoutesName
                                                    .edit_leadership_message,
                                                arguments: {
                                                  'message': message,
                                                },
                                              );

                                              if (!mounted) return;

                                              if (result == true) {
                                                _refreshMessages();
                                              }
                                              break;

                                            case MoreMenuAction.delete:
                                              _confirmDelete(message);
                                              break;

                                            case MoreMenuAction.view:
                                              Navigator.pushNamed(
                                                context,
                                                RoutesName
                                                    .view_leadership_message,
                                                arguments: {
                                                  'message': message,
                                                },
                                              );
                                              break;

                                            default:
                                              break;
                                          }
                                        },
                                      ),
                                      SizedBox(height: AppSizes.appbarGap),
                                      CustomStatusBadge(
                                        title:message.status!.toUpperCase(),
                                        size: AppSizes.cardTitle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: AppSizes.itemGap),

                              TextBodyStyleWidget(
                                title: "Message :",
                                color: color.primary,
                                maxLines: 1,
                              ),

                              SizedBox(height: AppSizes.appbarGap),

                              TextBodyStyleWidget(
                                title: message.message ?? "-",
                                color: color.primary,
                                fontbold: false,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                RoutesName.new_section_leadership_message,
              );

              if (!mounted) return;

              if (result == true) {
                _refreshMessages();
              }
            },
            child: Icon(
              Icons.add,
              color: color.cardBackground,
            ),
          ),
        ],
      ),
    );
  }
}