import '../../../domain/entities/store.dart';

class StoreModel extends Store {
  const StoreModel({
    required String id,
    required String company,
    required String tradeName,
    required String cnpj,
    required String phone,
    required String email,
    required String serial,
    required AddressModel address,
    required String partner,
    required double codePartner,
    required String size,
    required String segment,
    required List<int> operation,
    required bool active,
    required ScannerModel scanner,
    required bool offerta,
    required bool oppinar,
    required bool prazzo,
  }) : super(
          id: id,
          company: company,
          tradeName: tradeName,
          cnpj: cnpj,
          phone: phone,
          email: email,
          serial: serial,
          address: address,
          partner: partner,
          codePartner: codePartner,
          size: size,
          segment: segment,
          operation: operation,
          active: active,
          scanner: scanner,
          offerta: offerta,
          oppinar: oppinar,
          prazzo: prazzo,
        );

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? '',
      company: json['company'] ?? '',
      tradeName: json['tradeName'] ?? '',
      cnpj: json['cnpj'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      serial: json['serial'] ?? '',
      address: AddressModel(
        street: json['street'] ?? '',
        number: json['number'] ?? '',
        city: json['city'] ?? '',
        cityCode: json['cityCode'] ?? 0,
        state: json['state'] ?? '',
        stateCode: json['stateCode'] ?? 0,
        neighborhood: json['neighborhood'] ?? '',
      ),
      partner: json['partner'] ?? '',
      codePartner: (json['codePartner'] ?? 0.0).toDouble(),
      size: json['size'] ?? '',
      segment: json['segment'] ?? '',
      operation: json['operation'] is List
          ? List<int>.from(json['operation'])
          : <int>[],
      active: json['active'] ?? false,
      scanner: ScannerModel(
        active: json['scanner'] != null
            ? json['scanner']['active'] ?? false
            : false,
        beta:
            json['scanner'] != null ? json['scanner']['beta'] ?? false : false,
        expire: json['scanner'] != null ? json['scanner']['expire'] ?? 0 : 0,
      ),
      offerta: json['offerta'] ?? false,
      oppinar: json['oppinar'] ?? false,
      prazzo: json['prazzo'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final addressData = {
      'street': address.street,
      'number': address.number,
      'city': address.city,
      'cityCode': address.cityCode,
      'state': address.state,
      'stateCode': address.stateCode,
      'neighborhood': address.neighborhood,
    };

    return {
      'id': id,
      'company': company,
      'tradeName': tradeName,
      'cnpj': cnpj,
      'phone': phone,
      'email': email,
      'serial': serial,
      ...addressData,
      'partner': partner,
      'codePartner': codePartner,
      'size': size,
      'segment': segment,
      'operation': operation,
      'active': active,
      'scanner': {
        'active': scanner.active,
        'beta': scanner.beta,
        'expire': scanner.expire,
      },
      'offerta': offerta,
      'oppinar': oppinar,
      'prazzo': prazzo,
    };
  }

  factory StoreModel.fromEntity(Store entity) {
    return StoreModel(
      id: entity.id,
      company: entity.company,
      tradeName: entity.tradeName,
      cnpj: entity.cnpj,
      phone: entity.phone,
      email: entity.email,
      serial: entity.serial,
      address: AddressModel.fromEntity(entity.address),
      partner: entity.partner,
      codePartner: entity.codePartner,
      size: entity.size,
      segment: entity.segment,
      operation: entity.operation,
      active: entity.active,
      scanner: ScannerModel.fromEntity(entity.scanner),
      offerta: entity.offerta,
      oppinar: entity.oppinar,
      prazzo: entity.prazzo,
    );
  }

  StoreModel copyWithModel({
    String? id,
    String? company,
    String? tradeName,
    String? cnpj,
    String? phone,
    String? email,
    String? serial,
    AddressModel? address,
    String? partner,
    double? codePartner,
    String? size,
    String? segment,
    List<int>? operation,
    bool? active,
    ScannerModel? scanner,
    bool? offerta,
    bool? oppinar,
    bool? prazzo,
  }) {
    return StoreModel(
      id: id ?? this.id,
      company: company ?? this.company,
      tradeName: tradeName ?? this.tradeName,
      cnpj: cnpj ?? this.cnpj,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      serial: serial ?? this.serial,
      address: address ?? this.address as AddressModel,
      partner: partner ?? this.partner,
      codePartner: codePartner ?? this.codePartner,
      size: size ?? this.size,
      segment: segment ?? this.segment,
      operation: operation ?? this.operation,
      active: active ?? this.active,
      scanner: scanner ?? this.scanner as ScannerModel,
      offerta: offerta ?? this.offerta,
      oppinar: oppinar ?? this.oppinar,
      prazzo: prazzo ?? this.prazzo,
    );
  }
}

class AddressModel extends Address {
  const AddressModel({
    required String street,
    required String number,
    required String city,
    required int cityCode,
    required String state,
    required int stateCode,
    required String neighborhood,
  }) : super(
          street: street,
          number: number,
          city: city,
          cityCode: cityCode,
          state: state,
          stateCode: stateCode,
          neighborhood: neighborhood,
        );

  factory AddressModel.fromEntity(Address entity) {
    return AddressModel(
      street: entity.street,
      number: entity.number,
      city: entity.city,
      cityCode: entity.cityCode,
      state: entity.state,
      stateCode: entity.stateCode,
      neighborhood: entity.neighborhood,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'number': number,
      'city': city,
      'cityCode': cityCode,
      'state': state,
      'stateCode': stateCode,
      'neighborhood': neighborhood,
    };
  }
}

class ScannerModel extends Scanner {
  const ScannerModel({
    required bool active,
    required bool beta,
    required int expire,
  }) : super(
          active: active,
          beta: beta,
          expire: expire,
        );

  factory ScannerModel.fromEntity(Scanner entity) {
    return ScannerModel(
      active: entity.active,
      beta: entity.beta,
      expire: entity.expire,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'beta': beta,
      'expire': expire,
    };
  }
}
