import 'package:insurance_claim_agent/models/faq_model.dart';

class FaqService {
  Future<List<FaqModel>> getFaqs() async {
    // Simulate API call with sample data
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      FaqModel(
        id: 'FAQ001',
        question: 'Will you pay for a rental while my car is in the shop?',
        answer:
            'We offer an optional coverage that can pay for some or all of your rental car fees. Just check your policy or work with your claims rep to see how your coverages apply. Even if you don\'t have coverage for rental car fees, your claims rep can still help you find a rental and offer you a discount.',
        category: 'Rental Coverage',
      ),
      FaqModel(
        id: 'FAQ002',
        question: 'How is fault determined?',
        answer:
            'Liability, or fault, will be determined based on state laws and the circumstances of the accident. Depending on the facts of the loss, there may be shared responsibility.',
        category: 'Fault Determination',
      ),
      FaqModel(
        id: 'FAQ003',
        question: 'Who pays my deductible if I\'m not at fault?',
        answer:
            'If another person is found to be at fault for the accident, we\'ll work with you to make sure either they or their insurance company pays for your damages and losses and recover any money you may have paid toward your deductible or repairs. We can\'t promise that we\'ll always be able to recover your deductible from the other insurance company or driver, but we\'ll do our best to make it happen. If there is shared responsibility, the amount you receive back may be prorated.',
        category: 'Deductibles',
      ),
      FaqModel(
        id: 'FAQ004',
        question: 'Do I have to get my car repaired?',
        answer:
            'The decision to repair is yours—and it\'s OK to not repair your vehicle.\n\nIf you don\'t own your vehicle, check with your lienholder or leasing company before making a decision. They may require that you repair.\n\nIf you don\'t repair, we\'ll issue payment to you (minus your deductible).',
        category: 'Repairs',
      ),
      FaqModel(
        id: 'FAQ005',
        question: 'Do I have to report an accident or claim?',
        answer:
            'We encourage you to contact us any time you have a loss, especially if you\'re looking to get something repaired. Technically, you\'re required to report a claim even if it\'s not your fault. We\'re here to protect your interests and help when you\'re involved in an auto accident, no matter who was at fault. Reporting a claim is particularly important when people are injured or there\'s damage to another person\'s car or property. The best way for us to protect you is to open a claim. When you report a claim, we\'ll gather some basic information, then assign a claims rep to you. They\'ll provide more details on the claims process and answer any questions.\n\nYou can file a claim by logging in to your policy, using our mobile app, or by calling our claims center.\n\nIf you\'re not a Progressive customer, you can file a claim online as a guest or call us to report your claim.',
        category: 'Reporting Claims',
      ),
      FaqModel(
        id: 'FAQ006',
        question: 'How does the repair process work?',
        answer:
            'The process and repair/inspection options can differ depending on your product (home, car, boat, etc.). Your claims rep will be your main point of contact and walk you through your options and explain the process. For more details, see how the process works for:\n\nAuto\nMotorcycle/ATV\nBoat\nHome and renters\nRV',
        category: 'Repairs',
      ),
      FaqModel(
        id: 'FAQ007',
        question: 'How long do repairs take?',
        answer:
            'We resolve many property damage claims within 7 to 14 days, but repair times can vary greatly based on your vehicle, the damage, etc. No matter what, we\'ll work quickly and efficiently so you can get back to your normal routine.',
        category: 'Repairs',
      ),
      FaqModel(
        id: 'FAQ008',
        question: 'How will my claim affect my premium when my policy renews?',
        answer:
            'Your claim will not impact your current rate. But when you renew your policy, your rate may increase. We\'ll typically send you your new rate 30 days before your policy renewal date. Plus, we\'re here 24/7 to answer any questions and walk you through options that may lower your rate. There are some claims that typically won\'t raise your rate, like a claim that we didn\'t make a payment on or one with a payment of less than \$500.',
        category: 'Premiums',
      ),
      FaqModel(
        id: 'FAQ009',
        question:
            'My vehicle was determined to be a total loss. What does that mean?',
        answer:
            'Generally, a vehicle is a total loss when the cost to repair it and return it to its pre-loss condition is greater than the value of the vehicle. In some states, a vehicle may be a total loss if the repair costs would exceed a percentage (e.g., 80%) of the vehicle\'s value. A vehicle may also be a total loss if it cannot be returned to its pre-loss condition.\n\nSee more on total loss claims.',
        category: 'Total Loss',
      ),
      FaqModel(
        id: 'FAQ010',
        question: 'What are my repair and inspection options?',
        answer:
            'For auto repairs and inspections, you have a few options:\n\nNetwork repair shops: We have a network of repair shops all around the country for inspections and repairs. We\'ll even guarantee your repairs at network shops for as long as you own or lease your vehicle.\n\nAny other shop you\'d like: If you already have a repair shop in mind, you can use them too. However, if they\'re outside our network, we won\'t be able to guarantee your repairs.\n\nProgressive Photo Estimate: A mobile app that lets you take and submit photos and video of your damage. We\'ll then send an estimate electronically and you can use any of the repair options above if you choose to repair.',
        category: 'Repair Options',
      ),
      FaqModel(
        id: 'FAQ011',
        question: 'What if my repairs cost more than your estimate?',
        answer:
            'Your estimate includes all damages related to your loss that we can see without taking anything apart on your vehicle. If additional loss-related damage is found during the repair process, we\'ll re-inspect your vehicle. Finding additional damage isn\'t unusual—we can\'t always see all the damaged parts when writing the initial estimate. We\'ll work with you and the shop to update the estimate if needed.',
        category: 'Repair Estimates',
      ),
      FaqModel(
        id: 'FAQ012',
        question: 'Does car insurance cover mechanical problems?',
        answer:
            'Only if you have a vehicle protection plan like Progressive Vehicle Protection. In states where it\'s available, Progressive Vehicle Protection may cover major system failures, minor dents and dings, and even your lost, stolen, or damaged keys. This car insurance coverage is available in some states for newer cars, and it\'s renewable until the car is eight years old.',
        category: 'Coverage',
      ),
    ];
  }

  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return [
      'All',
      'Rental Coverage',
      'Fault Determination',
      'Deductibles',
      'Repairs',
      'Reporting Claims',
      'Premiums',
      'Total Loss',
      'Repair Options',
      'Repair Estimates',
      'Coverage',
    ];
  }
}
