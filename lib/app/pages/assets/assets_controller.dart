import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian_mobile/app/models/company_model.dart';
import 'package:tractian_mobile/app/models/asset_model.dart';
import 'package:tractian_mobile/app/models/component_model.dart';
import 'package:tractian_mobile/app/models/location_model.dart';

class AssetsController extends GetxController {
  CompanyModel? _company;
  CompanyModel? get company => _company;
  set company(CompanyModel? value) {
    _company = value;
    _filterAssets();
  }

  TextEditingController searchController = TextEditingController();
  Rx<int?> filterSelected = Rx<int?>(null);
  RxList<dynamic> filteredAssets = RxList<dynamic>([]);

  @override
  void onInit() {
    super.onInit();

    // Listen to changes in the search input to filter the assets wake up
    // the _filterAssets method
    searchController.addListener(_filterAssets);
  }

  @override
  void onClose() {
    searchController.removeListener(_filterAssets);
    searchController.dispose();
    filterSelected.value = null;
    super.onClose();
  }

  void changeFilter(int index) {
    if (filterSelected.value == index) {
      filterSelected.value = null;
    } else {
      searchController.clear();
      filterSelected.value = index;
    }
    _filterAssets();
  }

  // Verify if search query is empty and apply the correct filter
  void _filterAssets() {
    List<dynamic> assets = [...?company?.locations, ...?company?.assets];
    String searchQuery = searchController.text.toLowerCase();

    if (searchQuery.isEmpty) {
      filteredAssets.value = _applyFilterOnly(assets);
    } else {
      filteredAssets.value = _applySearchFilter(assets, searchQuery);
    }
  }

  // Filter the assets based on the selected filter (Energy Sensor or Critical Status)
  List<dynamic> _applyFilterOnly(List<dynamic> items) {
    List<dynamic> filteredItems = [];

    for (var item in items) {
      // Filter for locations
      if (item is LocationModel) {
        var filteredChildren = _applyFilterOnly(item.children);
        var filteredAssets = _applyFilterOnly(item.assets);

        if (filteredChildren.isNotEmpty ||
            filteredAssets.isNotEmpty ||
            _matchesFilter(item)) {
          LocationModel newItem = LocationModel(
            id: item.id,
            name: item.name,
            parentId: item.parentId,
          );
          // Add the filtered children and assets to the new item, casting them to the correct type
          newItem.children = filteredChildren.cast<LocationModel>();
          newItem.assets = filteredAssets.cast<AssetModel>();
          filteredItems.add(newItem);
        }
      } else if (item is AssetModel && item is! ComponentModel) {
        var filteredChildren = _applyFilterOnly(item.children);

        if (filteredChildren.isNotEmpty || _matchesFilter(item)) {
          AssetModel newItem = AssetModel(
            id: item.id,
            name: item.name,
            locationId: item.locationId,
            parentId: item.parentId,
          );
          newItem.children = filteredChildren.cast<AssetModel>();
          filteredItems.add(newItem);
        }
      } else if (item is ComponentModel) {
        if (_matchesFilter(item)) {
          ComponentModel newItem = ComponentModel(
            gatewayId: item.gatewayId,
            sentorId: item.sentorId,
            sensorType: item.sensorType,
            status: item.status,
            id: item.id,
            name: item.name,
            locationId: item.locationId,
            parentId: item.parentId,
          );
          filteredItems.add(newItem);
        }
      }
    }

    return filteredItems;
  }

  // Filter the assets based only on the search query
  List<dynamic> _applySearchFilter(List<dynamic> items, String searchQuery) {
    if (filterSelected.value != null) {
      filterSelected.value = null;
    }

    List<dynamic> filteredItems = [];

    for (var item in items) {
      if (item is LocationModel) {
        var filteredChildren = _applySearchFilter(item.children, searchQuery);
        var filteredAssets = _applySearchFilter(item.assets, searchQuery);

        if (item.name.toLowerCase().contains(searchQuery) ||
            filteredChildren.isNotEmpty ||
            filteredAssets.isNotEmpty) {
          LocationModel newItem = LocationModel(
            id: item.id,
            name: item.name,
            parentId: item.parentId,
          );
          newItem.children = filteredChildren.cast<LocationModel>();
          newItem.assets = filteredAssets.cast<AssetModel>();
          filteredItems.add(newItem);
        }
      } else if (item is AssetModel && item is! ComponentModel) {
        var filteredChildren = _applySearchFilter(item.children, searchQuery);

        if (item.name.toLowerCase().contains(searchQuery) ||
            filteredChildren.isNotEmpty) {
          AssetModel newItem = AssetModel(
            id: item.id,
            name: item.name,
            locationId: item.locationId,
            parentId: item.parentId,
          );
          newItem.children = filteredChildren.cast<AssetModel>();
          filteredItems.add(newItem);
        }
      } else if (item is ComponentModel) {
        if (item.name.toLowerCase().contains(searchQuery)) {
          ComponentModel newItem = ComponentModel(
            gatewayId: item.gatewayId,
            sentorId: item.sentorId,
            sensorType: item.sensorType,
            status: item.status,
            id: item.id,
            name: item.name,
            locationId: item.locationId,
            parentId: item.parentId,
          );
          filteredItems.add(newItem);
        }
      }
    }

    return filteredItems;
  }

  // Checks which filter is selected and calls the appropriate recursive function for the object type
  bool _matchesFilter(dynamic item) {
    if (filterSelected.value == null) return true;

    if (filterSelected.value == 0) {
      return _hasEnergySensor(item);
    } else if (filterSelected.value == 1) {
      return _hasCriticalStatus(item);
    }

    return false;
  }

  // Recursive function to check if the item has an energy sensor
  bool _hasEnergySensor(dynamic item) {
    if (item is ComponentModel && item.sensorType == SensorType.energy) {
      return true;
    }
    if (item is LocationModel || item is AssetModel) {
      return item.children.any(_hasEnergySensor) ||
          (item is LocationModel && item.assets.any(_hasEnergySensor));
    }
    return false;
  }

  // Recursive function to check if the item has a critical status
  bool _hasCriticalStatus(dynamic item) {
    if (item is ComponentModel && item.status == ComponentStatus.alert) {
      return true;
    }
    if (item is LocationModel || item is AssetModel) {
      return item.children.any(_hasCriticalStatus) ||
          (item is LocationModel && item.assets.any(_hasCriticalStatus));
    }
    return false;
  }
}
