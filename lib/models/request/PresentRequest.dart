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