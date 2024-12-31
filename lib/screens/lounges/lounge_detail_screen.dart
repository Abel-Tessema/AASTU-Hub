import 'package:aastu_hub/widgets/cards/lounge_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/lounge_controller.dart';
import '../../widgets/cards/lounge_meal_card.dart';
import '../../widgets/lounge_top_section.dart';

class LoungeDetailScreen extends StatelessWidget {
  LoungeDetailScreen({super.key});

  // Define an initial position for the draggable FAB
  final Rx<Offset> fabPosition = Offset(
    MediaQuery.of(Get.context!).size.width -
        MediaQuery.of(Get.context!).size.width * 0.18,
    MediaQuery.of(Get.context!).size.height -
        MediaQuery.of(Get.context!).size.height * 0.12,
  ).obs;
  final controller = Get.put(LoungeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoungeDetailScreenTopSection(
                image: controller.selectedLounge.value.imageUrl ?? '',
                name: controller.selectedLounge.value.name!,
                location: Location(
                    longitude: controller.selectedLounge.value.longitude ?? 0.0,
                    latitude: controller.selectedLounge.value.latitude ?? 0.0),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              if (controller.selectedLounge.value.foods != null &&
                  controller.selectedLounge.value.foods!.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    'Foods',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              if (controller.selectedLounge.value.foods != null &&
                  controller.selectedLounge.value.foods!.isNotEmpty)
                Obx(
                  () => Flexible(
                    fit: FlexFit.loose,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.selectedLounge.value.foods?.length,
                      itemBuilder: (context, index) {
                        var currentProduct =
                            controller.selectedLounge.value.foods![index];
                        return LoungeMealCard(
                            image: currentProduct.food.imageUrl ?? '',
                            name: currentProduct.food.name,
                            description: currentProduct.food.description ?? '',
                            price: currentProduct.price!.toString());
                      },
                    ),
                  ),
                ),
              const SizedBox(
                height: 16,
              ),
              if (controller.selectedLounge.value.beverages != null &&
                  controller.selectedLounge.value.beverages!.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    'Beverages',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              if (controller.selectedLounge.value.beverages != null &&
                  controller.selectedLounge.value.beverages!.isNotEmpty)
                Obx(
                  () => Flexible(
                    fit: FlexFit.loose,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          controller.selectedLounge.value.beverages?.length,
                      itemBuilder: (context, index) {
                        var currentProduct =
                            controller.selectedLounge.value.beverages![index];
                        return LoungeMealCard(
                            image: currentProduct.beverage.imageUrl ?? '',
                            name: currentProduct.beverage.name,
                            description:
                                currentProduct.beverage.description ?? '',
                            price: currentProduct.price!.toString());
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
