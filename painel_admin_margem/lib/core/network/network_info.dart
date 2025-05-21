import 'package:http/http.dart' as http;

/// Interface para verificar o estado da conexão com a internet
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementação concreta do NetworkInfo
class NetworkInfoImpl implements NetworkInfo {
  final String _testUrl = 'https://api.painelmargem.com.br';

  @override
  Future<bool> get isConnected async {
    try {
      final response = await http
          .get(Uri.parse(_testUrl))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
