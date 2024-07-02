class Decibel {
  final DateTime date;
  final double value;

  Decibel({required this.date, required this.value});

  factory Decibel.fromJson(Map<String, dynamic> json) {
    return Decibel(
      date: DateTime.parse(json['data']),
      value: double.parse(json['valor']),
    );
  }
}
