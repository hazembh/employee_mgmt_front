class Avance {
  final int idAmount;
  final double amount;
  final String dateAmount;

  Avance(
      {required this.idAmount, required this.amount, required this.dateAmount});

  factory Avance.fromJson(Map<String, dynamic> json) {
    return Avance(
      idAmount: json['idAmount'],
      amount: json['amount'],
      dateAmount: json['dateAmount'],
    );
  }
}