import 'package:flutter/material.dart';
import 'package:insurance_claim_agent/config/theme.dart';
import 'package:insurance_claim_agent/screens/chat_screen.dart';
import 'package:insurance_claim_agent/screens/faq_screen.dart';
import 'package:insurance_claim_agent/screens/dataset_viewer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Assistant'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.lightOlive,
          labelColor: AppTheme.lightOlive,
          unselectedLabelColor: AppTheme.textDark,
          tabs: const [
            Tab(text: 'Chat', icon: Icon(Icons.chat)),
            Tab(text: 'FAQs', icon: Icon(Icons.help_outline)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ChatScreen(), FaqScreen()],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                _showClaimStatusDialog();
              },
              backgroundColor: AppTheme.oliveGreen,
              heroTag: 'claimStatus',
              child: const Icon(Icons.search),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                _showDocumentUploadDialog();
              },
              backgroundColor: AppTheme.lightOlive,
              heroTag: 'documentUpload',
              child: const Icon(Icons.upload_file),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DatasetViewerScreen(),
                  ),
                );
              },
              backgroundColor: AppTheme.accentGreen,
              heroTag: 'datasetViewer',
              child: const Icon(Icons.data_usage),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showClaimStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Claim Status Lookup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Claim ID',
                hintText: 'Enter your claim ID',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // In a real app, fetch claim details
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Claim status lookup feature coming soon!'),
                    backgroundColor: AppTheme.oliveGreen,
                  ),
                );
              },
              child: const Text('Lookup Status'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDocumentUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Document'),
        content: const Text(
          'You can upload TXT, PDF, DOC, or DOCX files to ask questions about their content. '
          'Switch to the Chat tab and use the attachment button to upload a document.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Switch to chat tab
              _tabController.animateTo(0);
            },
            child: const Text('Go to Chat'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
