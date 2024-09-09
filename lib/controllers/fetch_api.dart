import 'package:http/http.dart' as http;
import 'dart:convert';

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
