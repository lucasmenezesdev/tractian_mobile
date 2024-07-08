import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tractian_mobile/app/repositories/company_repository.dart';

class InitialController extends GetxController {
  RxBool companiesIsLoading = false.obs;
  final companies = CompanyRepository.instance.companies;

  void fetchCompanies() async {
    companiesIsLoading.value = true;
    await CompanyRepository.instance.fetchCompanies();
    companiesIsLoading.value = false;
  }

  @override
  void onInit() {
    fetchCompanies();
    super.onInit();
  }
}
