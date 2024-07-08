import 'package:tractian_mobile/app/models/asset_model.dart';
import 'package:tractian_mobile/app/models/component_model.dart';
import 'package:tractian_mobile/app/models/location_model.dart';
import 'package:tractian_mobile/app/services/api_tractian_service.dart';

void main() async {
  final companies = await ApiTractianService.instance.getCompanies();

  final companie = companies[0];

  // print(companies);

  final locations =
      await ApiTractianService.instance.getLocations(companie['id']);

  // print(locations[0]);

  final assets = await ApiTractianService.instance.getAssets(companie['id']);

  fromJson(companie, locations, assets);
}

List<AssetModel> fromJson(Map<String, dynamic> companyJson,
    List<dynamic> locationsJson, List<dynamic> assetsJson) {
  try {
    List<LocationModel> locations = locationsJson.map((locationJson) {
      return LocationModel(
        id: locationJson['id'],
        name: locationJson['name'],
        parentId: locationJson['parentId'],
      );
    }).toList();

    List<AssetModel> assets = assetsJson.map((assetJson) {
      if (assetJson['sensorType'] != null) {
        return ComponentModel(
          id: assetJson['id'],
          name: assetJson['name'],
          parentId: assetJson['parentId'],
          locationId: assetJson['locationId'],
          sensorType: assetJson['sensorType'] == 'vibration'
              ? SensorType.vibration
              : SensorType.energy,
          gatewayId: assetJson['gatewayId'],
          sentorId: assetJson['sensorId'],
          status: assetJson['status'] == 'operating'
              ? ComponentStatus.operating
              : ComponentStatus.alert,
        );
      }
      return AssetModel(
        id: assetJson['id'],
        name: assetJson['name'],
        locationId: assetJson['locationId'],
        parentId: assetJson['parentId'],
      );
    }).toList();

    List<AssetModel> rootAssets = [];

    // Pega os assets que não tem parent e adiciona os filhos recursivamente
    for (var asset in assets) {
      if (asset.parentId == null) {
        asset.children.addAll(getChildrenAssets(assets, asset.id));
        rootAssets.add(asset);
      }
    }

    // Após isso, adiciona os root assets com localização a sua respectiva localização e remove do root
    List<AssetModel> assetsToRemove = [];
    for (var rootAsset in rootAssets) {
      if (rootAsset.locationId != null) {
        for (var location in locations) {
          if (rootAsset.locationId == location.id) {
            location.addAsset(rootAsset);
            assetsToRemove.add(rootAsset);
          }
        }
      }
    }

    // Remove os rootAssets da lista original após a iteração
    rootAssets.removeWhere((asset) => assetsToRemove.contains(asset));

    List<LocationModel> rootLocations = [];

    // Agora fazemos a search tree para encontrar as localizações filhas de cada localização
    for (var location in locations) {
      if (location.parentId == null) {
        location.children.addAll(getChildrenLocations(locations, location.id));
        rootLocations.add(location);
      }
    }

    print(rootLocations);
    print(rootAssets);

    return rootAssets;
  } catch (e) {
    print(e.toString());
    return [];
  }
}

//Get children assets from a list of assets and recursively get the children of the children
List<AssetModel> getChildrenAssets(List<AssetModel> assets, String assetId) {
  List<AssetModel> childrenAssets = [];
  for (var asset in assets) {
    if (asset.parentId == assetId) {
      asset.children.addAll(getChildrenAssets(assets, asset.id));
      childrenAssets.add(asset);
    }
  }
  return childrenAssets;
}

//Get children locations from a list of locations and recursively get the children of the children
List<LocationModel> getChildrenLocations(
    List<LocationModel> locations, String locationId) {
  List<LocationModel> childrenLocations = [];
  for (var location in locations) {
    if (location.parentId == locationId) {
      location.children.addAll(getChildrenLocations(locations, location.id));
      childrenLocations.add(location);
    }
  }
  return childrenLocations;
}
