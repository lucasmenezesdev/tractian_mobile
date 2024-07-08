import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian_mobile/app/pages/assets/assets_page.dart';
import 'package:tractian_mobile/app/pages/initial/components/button_widget.dart';
import 'package:tractian_mobile/app/pages/initial/initial_controller.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InitialController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/Logo-Tractian.png',
          width: 100,
        ),
      ),
      body: Center(
        child: Obx(
          () => controller.companiesIsLoading.value
              ? const CircularProgressIndicator()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: ListView.separated(
                      itemCount: controller.companies.length,
                      itemBuilder: (BuildContext context, int index) {
                        final company = controller.companies[index];
                        return ButtonWidget(
                            text: company.name,
                            onPressed: () {
                              Navigator.of(context).push<void>(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AssetsPage(company: company)));
                            });
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 30)),
                ),
        ),
      ),
    );
  }
}
