import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginResponse {
  final String message;
  final bool success;

  LoginResponse(this.message, this.success);
}

Future<LoginResponse> fetchLogin(String email, String password) async {
  try {
    final resp = await http.post(
      Uri.parse('http://172.17.96.1/api/v10/profiles/loginValidaFeira'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    var decodedResponse = jsonDecode(utf8.decode(resp.bodyBytes)) as Map;
    if (resp.statusCode == 200) {
      return LoginResponse(decodedResponse["ok"], true);
    } else {
      return LoginResponse(decodedResponse["erro"], false);
    }
  } catch (e) {
    print(e);
    return LoginResponse("Erro ao fazer login", false);
  }
}

fetchPresenca(String body) async {
  var client = http.Client();
  try {
    var response = await client.post(
        Uri.https(
            'app2hml.pr.sebrae.com.br', 'smart-api/public/presenca/espaco'),
        body: body);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    var uri = Uri.parse(decodedResponse['uri'] as String);
    print(await client.get(uri));
  } finally {
    client.close();
  }
}
