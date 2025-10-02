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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey, // Required to open drawer programmatically if needed
      appBar: AppBar(
        // Force the hamburger icon on all platforms/sizes
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppTheme.oliveGreen),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Claim Status Lookup'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                _showClaimStatusDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload Document'),
              onTap: () {
                Navigator.pop(context);
                _showDocumentUploadDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.data_usage),
              title: const Text('Dataset Viewer'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DatasetViewerScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Dataset Questions'),
              onTap: () {
                Navigator.pop(context);
                _showDatasetQuestionsDialog();
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ChatScreen(), FaqScreen()],
      ),
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

  void _showDatasetQuestionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dataset Questions'),
        content: const Text(
          'You can ask questions like:\n\n'
          '• What is the average vehicle age for customers with claim status "1"?\n'
          '• How many policies have a claim status of "0"?\n'
          '• What is the distribution of claim statuses in the dataset?\n'
          '• Show me policies with high ncap_rating and claim status "1"\n'
          '• What is the most common fuel type among policies with claims?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
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
