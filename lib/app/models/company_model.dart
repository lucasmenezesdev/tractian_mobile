import 'package:tractian_mobile/app/models/asset_model.dart';
import 'package:tractian_mobile/app/models/component_model.dart';
import 'package:tractian_mobile/app/models/location_model.dart';

class CompanyModel {
  String id;
  String name;

  List<LocationModel> locations = [];

  List<AssetModel> assets = [];

  CompanyModel({required this.id, required this.name});

  void fromJson(Map<String, dynamic> companyJson, List<dynamic> locationsJson,
      List<dynamic> assetsJson) {
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

      // Fetch the assets that don't have a parent and recursively add their children using a search tree
      for (var asset in assets) {
        if (asset.parentId == null) {
          asset.children.addAll(getChildrenAssets(assets, asset.id));
          rootAssets.add(asset);
        }
      }

      // After that, add the root assets with a location to their respective locations
      // and added in assetsToRemove list to remove them from the original list
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

      // Remove the rootAssets from the original list after the iteration
      rootAssets.removeWhere((asset) => assetsToRemove.contains(asset));

      List<LocationModel> rootLocations = [];

      // Now the search tree is performed to find the child locations of each location
      for (var location in locations) {
        if (location.parentId == null) {
          location.children
              .addAll(getChildrenLocations(locations, location.id));
          rootLocations.add(location);
        }
      }

      this.assets = rootAssets;
      this.locations = rootLocations;
    } catch (e) {
      print(e);
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

  @override
  String toString() {
    return 'CompanyModel(id: $id, name: $name, locations: $locations, assets: $assets)';
  }
}
