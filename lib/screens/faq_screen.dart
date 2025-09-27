import 'package:flutter/material.dart';
import 'package:insurance_claim_agent/config/theme.dart';
import 'package:insurance_claim_agent/models/faq_model.dart';
import 'package:insurance_claim_agent/services/faq_service.dart';
import 'package:insurance_claim_agent/widgets/faq_card.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final FaqService _faqService = FaqService();
  late Future<List<FaqModel>> _faqsFuture;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _faqsFuture = _faqService.getFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(
          child: FutureBuilder<List<FaqModel>>(
            future: _faqsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.oliveGreen,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No FAQs available',
                    style: TextStyle(color: AppTheme.textDark),
                  ),
                );
              }

              final faqs = _selectedCategory == 'All'
                  ? snapshot.data!
                  : snapshot.data!
                        .where((faq) => faq.category == _selectedCategory)
                        .toList();

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return FaqCard(faq: faqs[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: AppTheme.cardBackground,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildCategoryChip('All'),
            const SizedBox(width: 8),
            _buildCategoryChip('Claims'),
            const SizedBox(width: 8),
            _buildCategoryChip('Claims Process'),
            const SizedBox(width: 8),
            _buildCategoryChip('Claims Tracking'),
            const SizedBox(width: 8),
            _buildCategoryChip('Payments'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      backgroundColor: AppTheme.cardBackground,
      selectedColor: AppTheme.oliveGreen.withOpacity(0.3),
      checkmarkColor: AppTheme.oliveGreen,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.textLight : AppTheme.textDark,
      ),
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : 'All';
        });
      },
    );
  }
}
