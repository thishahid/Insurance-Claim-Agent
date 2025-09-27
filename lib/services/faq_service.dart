import 'package:insurance_claim_agent/models/faq_model.dart';

class FaqService {
  Future<List<FaqModel>> getFaqs() async {
    // Simulate API call with sample data
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      FaqModel(
        id: 'FAQ001',
        question: 'How do I file an insurance claim?',
        answer:
            'You can file a claim through our mobile app, website, or by calling our claims hotline. Make sure to have your policy number and details about the incident ready.',
        category: 'Claims',
      ),
      FaqModel(
        id: 'FAQ002',
        question: 'What documents do I need for a claim?',
        answer:
            'Required documents typically include a completed claim form, police report (if applicable), photos of damage, repair estimates, and any relevant medical reports.',
        category: 'Claims',
      ),
      FaqModel(
        id: 'FAQ003',
        question: 'How long does it take to process a claim?',
        answer:
            'Simple claims are usually processed within 7-10 business days. More complex claims may take 2-4 weeks depending on the investigation required.',
        category: 'Claims Process',
      ),
      FaqModel(
        id: 'FAQ004',
        question: 'Can I track my claim status?',
        answer:
            'Yes, you can track your claim status in real-time through our mobile app or website by entering your claim number.',
        category: 'Claims Tracking',
      ),
      FaqModel(
        id: 'FAQ005',
        question: 'What payment methods are available for claim payouts?',
        answer:
            'We offer direct deposit, check by mail, or electronic transfer to your preferred payment method.',
        category: 'Payments',
      ),
    ];
  }

  Future<List<FaqModel>> getFaqsByCategory(String category) async {
    final allFaqs = await getFaqs();
    return allFaqs.where((faq) => faq.category == category).toList();
  }
}
