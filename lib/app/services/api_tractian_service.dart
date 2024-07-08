// Class for access the Tractian API from endpoits, using the Dio package and
import 'package:dio/dio.dart';

class ApiTractianService {
  //Using the singleton pattern
  static final ApiTractianService instance = ApiTractianService._();

  ApiTractianService._();

  //Dio instance
  final Dio _dio = Dio();

  //Tractian API url
  final String _url = 'https://fake-api.tractian.com';

  //Get all companies
  Future<List<dynamic>> getCompanies() async {
    final result = await _dio.get('$_url/companies');

    return result.data;
  }

  //Get companie locations
  Future<List<dynamic>> getLocations(String companyId) async {
    final result = await _dio.get('$_url/companies/$companyId/locations');

    return result.data;
  }

  //Get companie assets
  Future<List<dynamic>> getAssets(String companyId) async {
    final result = await _dio.get('$_url/companies/$companyId/assets');

    return result.data;
  }
}
