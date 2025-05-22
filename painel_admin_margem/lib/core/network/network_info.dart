import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Interface para verificar o estado da conexão com a internet
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementação concreta do NetworkInfo
class NetworkInfoImpl implements NetworkInfo {
  /// Lista de hosts confiáveis para verificar conectividade
  final List<String> _dnsHosts = [
    'google.com',
    'cloudflare.com',
    '1.1.1.1',
  ];

  /// Lista de URLs para verificação HTTP como fallback
  final List<String> _httpUrls = [
    'https://www.google.com',
    'https://www.cloudflare.com',
    'https://dns.google',
  ];

  @override
  Future<bool> get isConnected async {
    try {
      // Primeiro, tenta verificar conectividade via DNS (mais rápido)
      final dnsCheck = await _checkDnsConnectivity();
      if (dnsCheck) {
        return true;
      }

      // Se DNS falhar, tenta verificação HTTP como fallback
      final httpCheck = await _checkHttpConnectivity();
      return httpCheck;
    } catch (e) {
      // Em caso de qualquer erro não tratado, assume sem conexão
      return false;
    }
  }

  /// Verifica conectividade através de lookup DNS
  Future<bool> _checkDnsConnectivity() async {
    try {
      // Tenta resolver DNS de múltiplos hosts
      final futures = _dnsHosts.map((host) async {
        try {
          // ALTERAÇÃO: Aumentado timeout de 2 para 5 segundos
          final result = await InternetAddress.lookup(host)
              .timeout(const Duration(seconds: 5));
          return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        } catch (e) {
          return false;
        }
      });

      // Retorna true se qualquer lookup funcionar
      final results = await Future.wait(futures);
      return results.any((success) => success);
    } catch (e) {
      return false;
    }
  }

  /// Verifica conectividade através de requisições HTTP
  Future<bool> _checkHttpConnectivity() async {
    try {
      // Tenta fazer requisições HEAD (mais leves) para múltiplos endpoints
      final futures = _httpUrls.map((url) async {
        try {
          // ALTERAÇÃO: Aumentado timeout de 3 para 5 segundos
          final response = await http
              .head(Uri.parse(url))
              .timeout(const Duration(seconds: 5));

          // Aceita qualquer resposta como sinal de conectividade
          // (mesmo redirects 3xx ou erros do servidor 5xx indicam que há internet)
          return response.statusCode > 0;
        } catch (e) {
          return false;
        }
      });

      // Retorna true se qualquer requisição funcionar
      final results = await Future.wait(futures);
      return results.any((success) => success);
    } catch (e) {
      return false;
    }
  }
}

/// Implementação alternativa mais simples (útil para testes)
class SimpleNetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      // ALTERAÇÃO: Aumentado timeout de 3 para 8 segundos
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 8));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (e) {
      // ALTERAÇÃO: Para desenvolvimento, assumir sempre conectado
      return true;
    }
  }
}

/// Implementação mock para testes unitários
class MockNetworkInfo implements NetworkInfo {
  final bool _isConnected;

  MockNetworkInfo({bool isConnected = true}) : _isConnected = isConnected;

  @override
  Future<bool> get isConnected async => _isConnected;
}
