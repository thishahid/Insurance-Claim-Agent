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
  late Future<List<String>> _categoriesFuture;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _faqsFuture = _faqService.getFaqs();
    _categoriesFuture = _faqService.getCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildSearchBar(),
        _buildCategoryFilter(),
        Expanded(child: _buildFaqList()),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.oliveGreen.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Claims FAQ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.oliveGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get the answers you need when filing a claim',
            style: TextStyle(fontSize: 16, color: AppTheme.textDark),
          ),
          const SizedBox(height: 16),
          Text(
            'Check out what questions other people are asking about their claim',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textDark,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search FAQs...',
          hintStyle: TextStyle(color: AppTheme.textDark),
          prefixIcon: const Icon(Icons.search, color: AppTheme.oliveGreen),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textDark),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppTheme.cardBackground,
        ),
        style: const TextStyle(color: AppTheme.textLight),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: AppTheme.cardBackground,
      child: FutureBuilder<List<String>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.oliveGreen),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading categories',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No categories available',
                style: TextStyle(color: AppTheme.textDark),
              ),
            );
          }

          final categories = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    backgroundColor: AppTheme.cardBackground,
                    selectedColor: AppTheme.oliveGreen.withValues(alpha: 0.3),
                    checkmarkColor: AppTheme.oliveGreen,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.textLight
                          : AppTheme.textDark,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : 'All';
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFaqList() {
    return FutureBuilder<List<FaqModel>>(
      future: _faqsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.oliveGreen),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading FAQs',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '${snapshot.error}',
                  style: TextStyle(color: AppTheme.textDark, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.help_outline, color: AppTheme.oliveGreen, size: 48),
                SizedBox(height: 16),
                Text(
                  'No FAQs available',
                  style: TextStyle(color: AppTheme.textLight, fontSize: 18),
                ),
              ],
            ),
          );
        }

        var faqs = snapshot.data!;

        // Filter by category
        if (_selectedCategory != 'All') {
          faqs = faqs
              .where((faq) => faq.category == _selectedCategory)
              .toList();
        }

        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          faqs = faqs
              .where(
                (faq) =>
                    faq.question.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    faq.answer.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
        }

        if (faqs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, color: AppTheme.textDark, size: 48),
                const SizedBox(height: 16),
                Text(
                  'No FAQs found',
                  style: TextStyle(color: AppTheme.textLight, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your search or filter criteria',
                  style: TextStyle(color: AppTheme.textDark, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return FaqCard(faq: faqs[index]);
          },
        );
      },
    );
  }
}
