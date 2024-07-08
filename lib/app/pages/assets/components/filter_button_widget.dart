// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'package:tractian_mobile/app/pages/assets/assets_controller.dart';

class FilterButtonWidget extends StatelessWidget {
  final AssetsController controller;
  final String text;
  final IconData icon;
  final int index;
  const FilterButtonWidget({
    super.key,
    required this.controller,
    required this.index,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 40,
          decoration: BoxDecoration(
            color: controller.filterSelected.value == index
                ? Theme.of(context).colorScheme.secondary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: controller.filterSelected.value == index
                ? Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : Border.all(
                    color: Colors.grey[400]!,
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon,
                  color: controller.filterSelected.value == index
                      ? Colors.white
                      : Colors.grey[400]!),
              const SizedBox(width: 5),
              Text(
                text,
                style: TextStyle(
                    color: controller.filterSelected.value == index
                        ? Colors.white
                        : Colors.grey[400]!),
              ),
            ],
          ),
        ),
        onTap: () {
          controller.changeFilter(index);
        },
      ),
    );
  }
}
