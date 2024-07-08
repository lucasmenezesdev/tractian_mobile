import 'package:flutter/material.dart';
import 'package:tractian_mobile/app/pages/assets/assets_controller.dart';

class SearchInputWidget extends StatelessWidget {
  final AssetsController controller;
  const SearchInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller.searchController,
        decoration: const InputDecoration(
          hintText: 'Buscar Ativo ou Local',
          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
