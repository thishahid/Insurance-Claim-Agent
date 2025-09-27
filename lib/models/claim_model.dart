class ClaimModel {
  final String id;
  final String policyNumber;
  final String claimType;
  final DateTime dateFiled;
  final String status;
  final double amount;
  final String description;
  final DateTime lastUpdated;

  ClaimModel({
    required this.id,
    required this.policyNumber,
    required this.claimType,
    required this.dateFiled,
    required this.status,
    required this.amount,
    required this.description,
    required this.lastUpdated,
  });

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
      id: json['id'],
      policyNumber: json['policyNumber'],
      claimType: json['claimType'],
      dateFiled: DateTime.parse(json['dateFiled']),
      status: json['status'],
      amount: json['amount'].toDouble(),
      description: json['description'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
