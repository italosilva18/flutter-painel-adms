import '../store/store_model.dart';

class StoreRequest {
  final String company;
  final String tradeName;
  final String cnpj;
  final String phone;
  final String email;
  final String serial;
  final String street;
  final String number;
  final String city;
  final int cityCode;
  final String state;
  final int stateCode;
  final String neighborhood;
  final String partner;
  final double codePartner;
  final String size;
  final String segment;
  final List<int> operation;
  final bool active;
  final Map<String, dynamic> scanner;
  final bool offerta;
  final bool oppinar;
  final bool prazzo;

  StoreRequest({
    required this.company,
    required this.tradeName,
    required this.cnpj,
    required this.phone,
    required this.email,
    required this.serial,
    required this.street,
    required this.number,
    required this.city,
    required this.cityCode,
    required this.state,
    required this.stateCode,
    required this.neighborhood,
    required this.partner,
    required this.codePartner,
    required this.size,
    required this.segment,
    required this.operation,
    required this.active,
    required this.scanner,
    required this.offerta,
    required this.oppinar,
    required this.prazzo,
  });

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'tradeName': tradeName,
      'cnpj': cnpj,
      'phone': phone,
      'email': email,
      'serial': serial,
      'street': street,
      'number': number,
      'city': city,
      'cityCode': cityCode,
      'state': state,
      'stateCode': stateCode,
      'neighborhood': neighborhood,
      'partner': partner,
      'codePartner': codePartner,
      'size': size,
      'segment': segment,
      'operation': operation,
      'active': active,
      'scanner': scanner,
      'offerta': offerta,
      'oppinar': oppinar,
      'prazzo': prazzo,
    };
  }

  factory StoreRequest.fromModel(StoreModel model) {
    return StoreRequest(
      company: model.company,
      tradeName: model.tradeName,
      cnpj: model.cnpj,
      phone: model.phone,
      email: model.email,
      serial: model.serial,
      street: model.address.street,
      number: model.address.number,
      city: model.address.city,
      cityCode: model.address.cityCode,
      state: model.address.state,
      stateCode: model.address.stateCode,
      neighborhood: model.address.neighborhood,
      partner: model.partner,
      codePartner: model.codePartner,
      size: model.size,
      segment: model.segment,
      operation: model.operation,
      active: model.active,
      scanner: (model.scanner as ScannerModel).toJson(),
      offerta: model.offerta,
      oppinar: model.oppinar,
      prazzo: model.prazzo,
    );
  }
}
