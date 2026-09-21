import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/theme/app_color.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';

import '../../data/model/Content/faq/faq_model.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/faq_view_model.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_status_badge.dart';

class FaqManagementScreen extends StatefulWidget {
  const FaqManagementScreen({super.key});

  @override
  State<FaqManagementScreen> createState() => _FaqManagementScreenState();
}

class _FaqManagementScreenState extends State<FaqManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  String _searchQuery = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshFaqList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshFaqList() async {
    await context.read<FaqViewModel>().getFaqApi();
  }

  // API তে FAQ list এর জন্য কোনো search query param documented নেই,
  // তাই client-side এ question/answer এর ভিতর filter করি
  List<FaqModel> _filteredFaqs(List<FaqModel> all) {
    if (_searchQuery.trim().isEmpty) return all;

    final query = _searchQuery.trim().toLowerCase();
    return all.where((faq) {
      final question = (faq.question ?? "").toLowerCase();
      final answer = (faq.answer ?? "").toLowerCase();
      return question.contains(query) || answer.contains(query);
    }).toList();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat('dd MMM yyyy').format(date);
  }

  Future<void> _confirmDelete(FaqModel faq) async {
    if (faq.id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete FAQ"),
        content: const Text("Are you sure you want to delete this FAQ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final viewModel = context.read<FaqViewModel>();
    final success = await viewModel.deleteFaq(faq.id!);

    if (!mounted) return;

    SnackBarMessage.showSnackBar(
      context,
      success
          ? "FAQ deleted successfully"
          : (viewModel.errorMessage ?? "Failed to delete FAQ"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshFaqList,
        child: CustomScrollView(
          slivers: [
            CustomSliverAppBar(
              title: "FAQ",
              showBackButton: true,
            ),

            SliverPadding(
              padding: EdgeInsets.all(AppSizes.screenPadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SearchTextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              hinText: "Search FAQ...",
                              controller: searchController,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
              ),
            ),

            Consumer<FaqViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.loading) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (viewModel.errorMessage != null &&
                    viewModel.faqList.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: TextBodyStyleWidget(
                          title: viewModel.errorMessage!,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  );
                }

                final faqs = _filteredFaqs(viewModel.faqList);

                if (faqs.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: TextBodyStyleWidget(
                          title: "No FAQ found",
                          color: color.primary,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                  ),
                  sliver: SliverList.builder(
                    itemCount: faqs.length,
                    itemBuilder: (context, index) {
                      final faq = faqs[index];

                      return Container(
                        margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                        child: CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question
                              TextBodyStyleWidget(
                                title: "Q: ${faq.question ?? ''}",
                                maxLines: 3,
                                color: color.textPrimary,
                                size: AppSizes.sectionTitle,
                              ),

                              SizedBox(height: AppSizes.itemGap),

                              // Answer
                              TextBodyStyleWidget(
                                title: "Ans: ${faq.answer ?? ''}",
                                maxLines: 6,
                                size: AppSizes.cardTitle,

                              ),

                              SizedBox(height: AppSizes.itemGap),
                               Divider(
       color: color.lightVersionOfPrimaryLightVersion,
       height: 1,),

                              // Status + Created date + Actions
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            CustomStatusBadge(
                                              title: (faq.isVisible ?? true)
                                                  ? "Visible"
                                                  : "Hidden",
                                              size: AppSizes.cardTitle,
                                              backgroundColor: (faq.isVisible ?? true) ? color.active : color.lightVersionOfPrimaryLightVersion,
                                              foregroundColor: (faq.isVisible ?? true) ? Colors.black : color.primary,

                                            ),
                                            SizedBox(
                                              height: AppSizes.smallGap,
                                            ),
                                            TextBodyStyleWidget(
                                              title:
                                              "Created On: ${_formatDate(faq.createDate ?? faq.createdAt)}",
                                              color: color.primary,
                                              fontbold: false,
                                              size: AppSizes.cardTitle,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                final result =
                                                await Navigator.pushNamed(
                                                  context,
                                                  RoutesName.edit_faq,
                                                  arguments: {"faq": faq},
                                                );

                                                if (!mounted) return;

                                                if (result == true) {
                                                  _refreshFaqList();
                                                }
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: color.primary,
                                                size: AppSizes.icon,
                                              ),
                                            ),
                                            SizedBox(
                                              width: AppSizes.itemGap,
                                            ),
                                            GestureDetector(
                                              onTap: () =>
                                                  _confirmDelete(faq),
                                              child: Icon(
                                                Icons
                                                    .delete_outline_outlined,
                                                color: Colors.redAccent,
                                                size: AppSizes.icon,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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

            SliverPadding(
              padding: EdgeInsets.only(bottom: AppSizes.sectionGap),
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
              final result =
              await Navigator.pushNamed(context, RoutesName.add_new_faq);

              if (!mounted) return;

              if (result == true) {
                _refreshFaqList();
              }
            },
            child: Icon(Icons.add, color: color.cardBackground),
          ),
        ],
      ),
    );
  }
}