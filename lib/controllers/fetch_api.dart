import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:validasebrae/models/request/PresentRequest.dart';
import 'package:validasebrae/models/response/DispResponse.dart';
import 'dart:convert';

import 'package:validasebrae/models/response/LoginResponse.dart';

var header = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  'Accept': 'application/json',
};

String urlCMS = dotenv.env['LOGIN_URL']!;
String url = dotenv.env['API_URL']!;

Future<LoginResponse> fetchLogin(String email, String password) async {
  try {
    final resp = await http.post(
      Uri.parse('$urlCMS'),
      headers: header,
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    var decodedResponse = jsonDecode(utf8.decode(resp.bodyBytes)) as Map;
    if (resp.statusCode == 200) {
      return LoginResponse(
          decodedResponse["ok"], true, decodedResponse["codAgente"] ?? 467);
    } else {
      return LoginResponse(decodedResponse["erro"], false, 0);
    }
  } catch (e) {
    print(e);
    return LoginResponse("Erro ao fazer login", false, 0);
  }
}

Future<List<DispResponse>?> fetchListStands() async {
  try {
    final resp = await http.get(
      Uri.parse(
          '$url' + dotenv.env['PARAMS_LISTAR']! + dotenv.env['DISP_COD']!),
      headers: header,
    );

    if (resp.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(resp.bodyBytes)) as List;
      List<DispResponse> listUse = [];
      for (var element in decodedResponse) {
        listUse.add(DispResponse(element["dscEspaco"], element["codEspaco"]));
      }
      return listUse;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

Future<bool> fetchPresencaLote(List<PresentRequest> dispList) async {
  try {
    List<Map<String, dynamic>> jsonArray =
        dispList.map((disp) => disp.toJson()).toList();

    final resp = await http.post(Uri.parse('$url' + dotenv.env['PARAMS_LOTE']!),
        headers: header, body: jsonEncode(jsonArray));

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> fetchPresenca(PresentRequest disp) async {
  try {
    final resp = await http.post(
        Uri.parse('$url' + dotenv.env['PARAMS_PRESENCA']!),
        headers: header,
        body: jsonEncode(disp.toJson()));
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
