import 'dart:math' as math;

/// Utilitário para conversão e formatação de entradas
class InputConverter {
  /// Remove todos os caracteres não numéricos
  String removeNonDigits(String text) {
    return text.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Formata um CNPJ (14 dígitos) para o formato XX.XXX.XXX/XXXX-XX
  String formatCnpj(String cnpj) {
    final digits = removeNonDigits(cnpj);
    if (digits.length != 14) return cnpj;

    return '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8, 12)}-${digits.substring(12)}';
  }

  /// Formata um telefone para o formato (XX) XXXXX-XXXX ou (XX) XXXX-XXXX
  String formatPhone(String phone) {
    final digits = removeNonDigits(phone);
    if (digits.length < 10) return phone;

    if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
    } else {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
    }
  }

  /// Valida se um CNPJ é válido (algoritmo de verificação)
  bool isValidCnpj(String cnpj) {
    final digits = removeNonDigits(cnpj);
    if (digits.length != 14) return false;

    // Verify if all digits are the same
    if (RegExp(r'^(\d)\1*$').hasMatch(digits)) return false;

    // Calculate first check digit
    int sum = 0;
    int weight = 5;
    for (int i = 0; i < 12; i++) {
      sum += int.parse(digits[i]) * weight;
      weight = weight == 2 ? 9 : weight - 1;
    }
    int digit1 = 11 - (sum % 11);
    if (digit1 > 9) digit1 = 0;

    // Calculate second check digit
    sum = 0;
    weight = 6;
    for (int i = 0; i < 13; i++) {
      sum += int.parse(i < 12 ? digits[i] : digit1.toString()) * weight;
      weight = weight == 2 ? 9 : weight - 1;
    }
    int digit2 = 11 - (sum % 11);
    if (digit2 > 9) digit2 = 0;

    // Check if calculated check digits match the original ones
    return digit1 == int.parse(digits[12]) && digit2 == int.parse(digits[13]);
  }

  /// Formata um CPF (11 dígitos) para o formato XXX.XXX.XXX-XX
  String formatCpf(String cpf) {
    final digits = removeNonDigits(cpf);
    if (digits.length != 11) return cpf;

    return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9)}';
  }

  /// Formata um CEP (8 dígitos) para o formato XXXXX-XXX
  String formatCep(String cep) {
    final digits = removeNonDigits(cep);
    if (digits.length != 8) return cep;

    return '${digits.substring(0, 5)}-${digits.substring(5)}';
  }

  /// Formata um valor monetário para o formato R$ X.XXX,XX
  String formatCurrency(double value) {
    return 'R\$ ${formatNumber(value)}';
  }

  /// Formata um número com separadores de milhar
  String formatNumber(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    // Adiciona pontos a cada 3 dígitos
    String formatted = '';
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        formatted += '.';
      }
      formatted += intPart[i];
    }

    return '$formatted,$decPart';
  }

  /// Converte uma string para double
  double stringToDouble(String value) {
    if (value.isEmpty) return 0;

    final cleanValue = value
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();

    return double.tryParse(cleanValue) ?? 0;
  }
}
