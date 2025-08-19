import 'package:gemai/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/history_controller.dart';
import '../widgets/history_list_item.dart';

class HistoryView extends StatelessWidget {
  HistoryView({super.key});
  final controller = Get.put(HistoryController());
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        controller.fetchNextPage();
      }
    });
    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshHistory();
      },
      child: Obx(() {
        if (controller.items.isEmpty && controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.items.isEmpty) {
          return Center(child: Text('history_no_history'.tr));
        }
        return ListView.builder(
          controller: scrollController,
          itemCount:
              controller.items.length + (controller.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == 0) {
              // Listenin başına boşluk ekle
              return Column(
                children: [
                  const SizedBox(height: 8),
                  HistoryListItem(
                    item: controller.items[index],
                    index: index,
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.result,
                        arguments: controller.items[index].id,
                      );
                    },
                  ),
                ],
              );
            }
            if (index < controller.items.length) {
              final item = controller.items[index];
              return HistoryListItem(
                item: item,
                index: index,
                onTap: () {
                  Get.toNamed(AppRoutes.result, arguments: item.id);
                },
              );
            } else {
              // Yükleniyor göstergesi
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        );
      }),
    );
  }
}
