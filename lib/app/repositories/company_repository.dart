import 'package:tractian_mobile/app/models/company_model.dart';
import 'package:tractian_mobile/app/services/api_tractian_service.dart';

class CompanyRepository {
  List<CompanyModel> companies = [];

  static final CompanyRepository instance = CompanyRepository._();

  CompanyRepository._();

  Future<void> fetchCompanies() async {
    final apiTractianService = ApiTractianService.instance;

    try {
      // Fetch companies from the API
      List<dynamic> companiesResponse = await apiTractianService.getCompanies();

      // Fetch locations and assets for each company
      for (var company in companiesResponse) {
        List<dynamic> locationsResponse =
            await apiTractianService.getLocations(company['id']);
        List<dynamic> assetsResponse =
            await apiTractianService.getAssets(company['id']);

        CompanyModel newCompany =
            CompanyModel(id: company['id'], name: company['name']);

        newCompany.fromJson(company, locationsResponse, assetsResponse);

        companies.add(newCompany);
      }
    } catch (e) {
      print(e);
    }
  }
}
