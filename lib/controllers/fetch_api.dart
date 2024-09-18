import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginResponse {
  final String message;
  final bool success;
  final int codAgente;

  LoginResponse(this.message, this.success, this.codAgente);
}

class DispResponse {
  final String dscEspaco;
  final int codEspaco;

  DispResponse(this.dscEspaco, this.codEspaco);
}

class PresentRequest {
  final int codDisponibilizacao;
  final int codEspaco;
  final String qrCode;
  final int codAgente;

  PresentRequest(
      {required this.codDisponibilizacao,
      required this.codEspaco,
      required this.qrCode,
      required this.codAgente});

  factory PresentRequest.fromJson(Map<String, dynamic> json) {
    return PresentRequest(
        codDisponibilizacao: json['codDisponibilizacao'],
        codEspaco: json['codEspaco'],
        qrCode: json['qrCode'],
        codAgente: json['codAgente']);
  }

  Map<String, dynamic> toJson() {
    return {
      'codDisponibilizacao': codDisponibilizacao,
      'codEspaco': codEspaco,
      'qrCode': qrCode,
      'codAgente': codAgente
    };
  }
}

var header = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  'Accept': 'application/json',
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
    var disp = dotenv.env['DISP_COD'] ?? "123456";
    final resp = await http.get(
      Uri.parse(
          'http://apihml.pr.sebrae.com.br/smart-api/public/presenca/espaco/listar?disponibilizacao=$disp'),
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

    final resp = await http.post(
        Uri.parse(
            'http://apihml.pr.sebrae.com.br/smart-api/public/presenca/espaco/lote'),
        headers: header,
        body: jsonEncode(jsonArray));

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
        Uri.parse(
            'http://apihml.pr.sebrae.com.br/smart-api/public/presenca/espaco/presenca'),
        headers: header,
        body: jsonEncode(disp.toJson()));
    if (resp.statusCode == 200) {
      var decodedResponse =
          jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
