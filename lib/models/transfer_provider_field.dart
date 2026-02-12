import '/helper/safety_model.dart';
import 'provider_field.dart';

class TransferProviderFieldModel extends SafetyModel {
  int id = 0;
  String fieldValue = '';
  int transactionId = 0;
  int providerFieldId = 0;
  ProviderFieldModel field = ProviderFieldModel();

  TransferProviderFieldModel({
    this.id = 0,
    this.fieldValue = '',
    this.transactionId = 0,
    this.providerFieldId = 0,
  });

  TransferProviderFieldModel.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    fieldValue = stringFromJson(json, 'fieldValue');
    transactionId = intFromJson(json, 'transactionId');
    providerFieldId = intFromJson(json, 'providerFieldId');
    if (json['field'] != null) {
      field = ProviderFieldModel.fromJson(json['field']);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fieldValue': fieldValue,
      'transactionId': transactionId,
      'providerFieldId': providerFieldId,
      // 'field': field.toJson(),
    };
  }
}
