// ignore_for_file: public_member_api_docs, sort_constructors_first
//Se o item tiver um sensorType, significa que ele é um componente.
//Se ele não tiver um location ou um parentId, significa que ele não
//é curtido de nenhum asset ou location na árvore.

class AssetModel {
  String id;
  String name;
  String? locationId;
  String? parentId;
  List<AssetModel> children = [];

  AssetModel({
    required this.id,
    required this.name,
    this.locationId,
    this.parentId,
  });

  @override
  String toString() {
    return 'AssetModel(id: $id, name: $name, locationId: $locationId, parentId: $parentId, children: $children)';
  }
}
