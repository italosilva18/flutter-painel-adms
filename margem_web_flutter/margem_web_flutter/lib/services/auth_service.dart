// auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = 'https://api.painelmargem.com.br/mobile/login';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print(
            'Falha ao realizar o login. Código de status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro na requisição: $e');
      return null;
    }
  }
}
