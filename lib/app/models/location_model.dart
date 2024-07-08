// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tractian_mobile/app/models/asset_model.dart';

class LocationModel {
  String id;
  String name;
  String? parentId;
  List<AssetModel> assets = [];
  List<LocationModel> children = [];

  LocationModel({
    required this.id,
    required this.name,
    this.parentId,
  });

  void addAsset(AssetModel asset) {
    assets.add(asset);
  }

  @override
  String toString() {
    return 'LocationModel(id: $id, name: $name, parentId: $parentId, assets: $assets, children: $children)';
  }
}
