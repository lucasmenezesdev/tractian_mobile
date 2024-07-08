import 'package:tractian_mobile/app/models/asset_model.dart';

enum ComponentStatus { operating, alert }

enum SensorType { vibration, energy }

class ComponentModel extends AssetModel {
  String gatewayId;
  String sentorId;
  SensorType sensorType;
  ComponentStatus status;

  ComponentModel(
      {required this.gatewayId,
      required this.sentorId,
      required this.sensorType,
      required this.status,
      required super.id,
      required super.name,
      super.locationId,
      super.parentId});

  @override
  String toString() {
    return 'ComponentModel(id: $id, name: $name, locationId: $locationId, parentId: $parentId, gatewayId: $gatewayId, sentorId: $sentorId, sensorType: $sensorType, status: $status), children: $children';
  }
}
