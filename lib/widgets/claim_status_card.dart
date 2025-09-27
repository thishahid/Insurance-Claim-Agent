import 'package:flutter/material.dart';
import 'package:insurance_claim_agent/config/theme.dart';
import 'package:insurance_claim_agent/models/claim_model.dart';

class ClaimStatusCard extends StatelessWidget {
  final ClaimModel claim;

  const ClaimStatusCard({super.key, required this.claim});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardBackground,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.oliveGreen.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Claim #${claim.id}',
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(claim.status).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    claim.status,
                    style: TextStyle(
                      color: _getStatusColor(claim.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              claim.claimType,
              style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppTheme.oliveGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Filed: ${_formatDate(claim.dateFiled)}',
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.update, color: AppTheme.oliveGreen, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Updated: ${_formatDate(claim.lastUpdated)}',
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.attach_money,
                  color: AppTheme.oliveGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Amount: \$${claim.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              claim.description,
              style: const TextStyle(color: AppTheme.textDark),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // View details
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Claim details view coming soon!'),
                        backgroundColor: AppTheme.oliveGreen,
                      ),
                    );
                  },
                  child: const Text(
                    'View Details',
                    style: TextStyle(color: AppTheme.lightOlive),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
      case 'in review':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return AppTheme.oliveGreen;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
