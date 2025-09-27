import 'package:insurance_claim_agent/models/claim_model.dart';

class ClaimService {
  Future<List<ClaimModel>> getClaims() async {
    // Simulate API call with sample data
    await Future.delayed(const Duration(seconds: 1));

    return [
      ClaimModel(
        id: 'CLM001',
        policyNumber: 'POL123456',
        claimType: 'Auto Accident',
        dateFiled: DateTime(2023, 10, 15),
        status: 'In Review',
        amount: 2500.00,
        description: 'Rear-end collision at intersection',
        lastUpdated: DateTime(2023, 10, 20),
      ),
      ClaimModel(
        id: 'CLM002',
        policyNumber: 'POL789012',
        claimType: 'Property Damage',
        dateFiled: DateTime(2023, 11, 5),
        status: 'Approved',
        amount: 1200.50,
        description: 'Water damage from broken pipe',
        lastUpdated: DateTime(2023, 11, 18),
      ),
      ClaimModel(
        id: 'CLM003',
        policyNumber: 'POL345678',
        claimType: 'Medical',
        dateFiled: DateTime(2023, 12, 1),
        status: 'Pending Documentation',
        amount: 3500.00,
        description: 'Emergency room visit after fall',
        lastUpdated: DateTime(2023, 12, 10),
      ),
    ];
  }

  Future<ClaimModel?> getClaimById(String id) async {
    final claims = await getClaims();
    try {
      return claims.firstWhere((claim) => claim.id == id);
    } catch (e) {
      return null;
    }
  }
}
