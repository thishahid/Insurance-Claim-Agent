import 'package:flutter/material.dart';
import 'package:insurance_claim_agent/models/faq_model.dart';
import 'package:insurance_claim_agent/config/theme.dart';

class FaqCard extends StatefulWidget {
  final FaqModel faq;

  const FaqCard({super.key, required this.faq});

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool _isExpanded = false;

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
      child: ExpansionTile(
        title: Text(
          widget.faq.question,
          style: const TextStyle(
            color: AppTheme.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          widget.faq.category,
          style: const TextStyle(color: AppTheme.lightOlive, fontSize: 12),
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: AppTheme.oliveGreen,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.faq.answer,
              style: const TextStyle(color: AppTheme.textDark),
            ),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  // Share FAQ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share feature coming soon!'),
                      backgroundColor: AppTheme.oliveGreen,
                    ),
                  );
                },
                child: const Text(
                  'Share',
                  style: TextStyle(color: AppTheme.lightOlive),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Copy to clipboard
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied to clipboard!'),
                      backgroundColor: AppTheme.oliveGreen,
                    ),
                  );
                },
                child: const Text(
                  'Copy',
                  style: TextStyle(color: AppTheme.lightOlive),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
