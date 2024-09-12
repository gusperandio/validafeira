import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginResponse {
  final String message;
  final bool success;

  LoginResponse(this.message, this.success);
}

var header = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
};

Future<LoginResponse> fetchLogin(String email, String password) async {
  try {
    final resp = await http.post(
      Uri.parse(
          'https://hom-meusebrae-cms-apps.pr.sebrae.com.br/api/v10/profiles/loginValidaFeira'),
      headers: header,
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

Future<LoginResponse> fetchListStands(String disp) async {
  try {
    final resp = await http.post(
        Uri.parse(
            'http://apihml.pr.sebrae.com.br/smart-api/public/presenca/espaco/listar?disponibilizacao=$disp'),
        headers: header);
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
