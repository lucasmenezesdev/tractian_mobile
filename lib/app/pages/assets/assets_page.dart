import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian_mobile/app/models/asset_model.dart';
import 'package:tractian_mobile/app/models/company_model.dart';
import 'package:tractian_mobile/app/models/component_model.dart';
import 'package:tractian_mobile/app/models/location_model.dart';
import 'package:tractian_mobile/app/pages/assets/assets_controller.dart';
import 'package:tractian_mobile/app/pages/assets/components/filter_button_widget.dart';
import 'package:tractian_mobile/app/pages/assets/components/search_input_widget.dart';

class AssetsPage extends StatelessWidget {
  final CompanyModel company;

  const AssetsPage({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AssetsController());
    final controller = Get.find<AssetsController>();

    controller.company = company;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: Text(company.name, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                SearchInputWidget(controller: controller),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FilterButtonWidget(
                      controller: controller,
                      index: 0,
                      icon: Icons.bolt,
                      text: 'Sensor de Energia',
                    ),
                    const SizedBox(width: 20),
                    FilterButtonWidget(
                      controller: controller,
                      index: 1,
                      icon: Icons.error,
                      text: 'Crítico',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView(
                children: buildTile(controller.filteredAssets, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Constructs tiles for each child, using a structure similar to the one used to
  // organize API data. This is done recursively.
  List<Widget> buildTile(List items, BuildContext context) {
    List<Widget> tiles = [];

    for (var item in items) {
      tiles.add(
        ExpansionTile(
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          trailing: item is AssetModel
              ? item.children.isNotEmpty
                  ? null
                  : const SizedBox()
              : [...item.children, ...item.assets].isNotEmpty
                  ? null
                  : const SizedBox(),
          childrenPadding: const EdgeInsets.only(left: 20),
          leading: Image.asset(
              item is LocationModel
                  ? 'assets/icons/location.png'
                  : item is ComponentModel
                      ? 'assets/icons/component.png'
                      : 'assets/icons/asset.png',
              width: 20),
          title: item is ComponentModel
              ? Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.name,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (item.status == ComponentStatus.alert)
                      Icon(
                        Icons.circle,
                        color: Theme.of(context).colorScheme.error,
                        size: 16,
                      )
                    else if (item.sensorType == SensorType.energy)
                      Icon(
                        Icons.bolt,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 16,
                      )
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(item.name)),
                  ],
                ),
          children: buildTile(
              item is AssetModel
                  ? item.children
                  : [...item.children, ...item.assets],
              context),
        ),
      );
    }

    return tiles;
  }
}
