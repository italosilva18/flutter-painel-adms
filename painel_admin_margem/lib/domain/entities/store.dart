import 'package:equatable/equatable.dart';

/// Entidade de loja para o domínio
class Store extends Equatable {
  final String id;
  final String company;
  final String tradeName;
  final String cnpj;
  final String phone;
  final String email;
  final String serial;
  final Address address;
  final String partner;
  final double codePartner;
  final String size;
  final String segment;
  final List<int> operation;
  final bool active;
  final Scanner scanner;
  final bool offerta;
  final bool oppinar;
  final bool prazzo;

  const Store({
    required this.id,
    required this.company,
    required this.tradeName,
    required this.cnpj,
    required this.phone,
    required this.email,
    required this.serial,
    required this.address,
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

  /// Cria uma cópia da loja com valores atualizados
  Store copyWith({
    String? id,
    String? company,
    String? tradeName,
    String? cnpj,
    String? phone,
    String? email,
    String? serial,
    Address? address,
    String? partner,
    double? codePartner,
    String? size,
    String? segment,
    List<int>? operation,
    bool? active,
    Scanner? scanner,
    bool? offerta,
    bool? oppinar,
    bool? prazzo,
  }) {
    return Store(
      id: id ?? this.id,
      company: company ?? this.company,
      tradeName: tradeName ?? this.tradeName,
      cnpj: cnpj ?? this.cnpj,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      serial: serial ?? this.serial,
      address: address ?? this.address,
      partner: partner ?? this.partner,
      codePartner: codePartner ?? this.codePartner,
      size: size ?? this.size,
      segment: segment ?? this.segment,
      operation: operation ?? this.operation,
      active: active ?? this.active,
      scanner: scanner ?? this.scanner,
      offerta: offerta ?? this.offerta,
      oppinar: oppinar ?? this.oppinar,
      prazzo: prazzo ?? this.prazzo,
    );
  }

  @override
  List<Object?> get props => [
        id,
        company,
        tradeName,
        cnpj,
        phone,
        email,
        serial,
        address,
        partner,
        codePartner,
        size,
        segment,
        operation,
        active,
        scanner,
        offerta,
        oppinar,
        prazzo,
      ];

  @override
  bool get stringify => true;
}

/// Entidade de endereço
class Address extends Equatable {
  final String street;
  final String number;
  final String city;
  final int cityCode;
  final String state;
  final int stateCode;
  final String neighborhood;

  const Address({
    required this.street,
    required this.number,
    required this.city,
    required this.cityCode,
    required this.state,
    required this.stateCode,
    required this.neighborhood,
  });

  /// Cria uma cópia do endereço com valores atualizados
  Address copyWith({
    String? street,
    String? number,
    String? city,
    int? cityCode,
    String? state,
    int? stateCode,
    String? neighborhood,
  }) {
    return Address(
      street: street ?? this.street,
      number: number ?? this.number,
      city: city ?? this.city,
      cityCode: cityCode ?? this.cityCode,
      state: state ?? this.state,
      stateCode: stateCode ?? this.stateCode,
      neighborhood: neighborhood ?? this.neighborhood,
    );
  }

  @override
  List<Object?> get props => [
        street,
        number,
        city,
        cityCode,
        state,
        stateCode,
        neighborhood,
      ];

  @override
  bool get stringify => true;
}

/// Entidade de scanner
class Scanner extends Equatable {
  final bool active;
  final bool beta;
  final int expire;

  const Scanner({
    required this.active,
    required this.beta,
    required this.expire,
  });

  /// Cria uma cópia do scanner com valores atualizados
  Scanner copyWith({
    bool? active,
    bool? beta,
    int? expire,
  }) {
    return Scanner(
      active: active ?? this.active,
      beta: beta ?? this.beta,
      expire: expire ?? this.expire,
    );
  }

  @override
  List<Object?> get props => [active, beta, expire];

  @override
  bool get stringify => true;
}
