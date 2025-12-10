import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class TemplateGeneratorPage extends StatefulWidget {
  const TemplateGeneratorPage({super.key});

  @override
  State<TemplateGeneratorPage> createState() => _TemplateGeneratorPageState();
}

class _TemplateGeneratorPageState extends State<TemplateGeneratorPage>
    with TickerProviderStateMixin {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  bool _isGenerating = false;
  String _generatedTemplate = '';
  List<DownloadedTemplate> _downloadedTemplates = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDownloadedTemplates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _topicController.dispose();
    _gradeLevelController.dispose();
    _subjectController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _loadDownloadedTemplates() async {
    final directory = await getApplicationDocumentsDirectory();
    final templatesFile = File('${directory.path}/downloaded_templates.json');

    if (await templatesFile.exists()) {
      final content = await templatesFile.readAsString();
      final List<dynamic> jsonList = json.decode(content);
      setState(() {
        _downloadedTemplates = jsonList
            .map((json) => DownloadedTemplate.fromJson(json))
            .toList();
      });
    }
  }

  Future<void> _saveDownloadedTemplates() async {
    final directory = await getApplicationDocumentsDirectory();
    final templatesFile = File('${directory.path}/downloaded_templates.json');

    final jsonList = _downloadedTemplates
        .map((template) => template.toJson())
        .toList();
    await templatesFile.writeAsString(json.encode(jsonList));
  }

  Future<void> _generateTemplate() async {
    if (_topicController.text.trim().isEmpty ||
        _gradeLevelController.text.trim().isEmpty ||
        _subjectController.text.trim().isEmpty) {
      _showErrorSnackBar('Please fill in all required fields');
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final prompt =
          '''
Generate a comprehensive educational template for the following details:

Topic: ${_topicController.text}
Grade Level: ${_gradeLevelController.text}
Subject: ${_subjectController.text}
Duration: ${_durationController.text.isNotEmpty ? _durationController.text : 'Not specified'}

Please create a well-structured template that includes:
1. Learning Objectives
2. Materials Needed
3. Lesson Activities (with time allocation)
4. Assessment Methods
5. Homework/Extension Activities
6. Key Vocabulary
7. Differentiation Strategies

Format the response in a clear, organized manner that can be easily used by educators.
      ''';

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer YOUR_API_KEY_HERE', // Replace with actual API key
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert educational content creator.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 1500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'];
        setState(() {
          _generatedTemplate = content;
        });
      } else {
        _showErrorSnackBar('Failed to generate template. Please try again.');
        // For demo purposes, generate a mock template
        _generateMockTemplate();
      }
    } catch (e) {
      _showErrorSnackBar('Error generating template. Using demo content.');
      // For demo purposes, generate a mock template
      _generateMockTemplate();
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _generateMockTemplate() {
    final mockTemplate =
        '''
# Educational Template: ${_topicController.text}

## Learning Objectives
- Students will understand the fundamental concepts of ${_topicController.text}
- Students will be able to apply knowledge in practical scenarios
- Students will develop critical thinking skills related to the topic

## Materials Needed
- Textbooks and reference materials
- Digital devices (tablets/laptops)
- Writing materials
- Visual aids and presentations

## Lesson Activities
1. **Introduction (10 minutes)**
   - Engage students with a thought-provoking question
   - Present learning objectives

2. **Main Content (30 minutes)**
   - Direct instruction on key concepts
   - Interactive demonstrations
   - Student participation activities

3. **Practice Activity (20 minutes)**
   - Hands-on exercises
   - Group collaboration
   - Peer learning opportunities

4. **Assessment (15 minutes)**
   - Formative assessment through questioning
   - Quick quiz or activity
   - Reflection on learning

## Assessment Methods
- Class participation and discussion
- Completed worksheets
- Exit tickets
- Observation of practical application

## Homework/Extension Activities
- Reading assignment on advanced topics
- Research project related to ${_topicController.text}
- Practical application exercises

## Key Vocabulary
- List important terms and definitions
- Include context and examples

## Differentiation Strategies
- For struggling students: Provide additional support and simplified materials
- For advanced students: Offer extension activities and challenges
- For visual learners: Include diagrams and visual aids
- For kinesthetic learners: Incorporate hands-on activities

---
*Generated for Grade ${_gradeLevelController.text} - ${_subjectController.text}*
    ''';
    setState(() {
      _generatedTemplate = mockTemplate;
    });
  }

  Future<void> _downloadTemplate() async {
    if (_generatedTemplate.isEmpty) {
      _showErrorSnackBar('No template to download');
      return;
    }

    try {
      final fileName = 'template_${DateTime.now().millisecondsSinceEpoch}.txt';
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(_generatedTemplate);

      final result = file.path;

      if (result.isNotEmpty) {
        final downloadedTemplate = DownloadedTemplate(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: '${_topicController.text} Template',
          subject: _subjectController.text,
          gradeLevel: _gradeLevelController.text,
          content: _generatedTemplate,
          downloadDate: DateTime.now(),
          filePath: result,
        );

        setState(() {
          _downloadedTemplates.insert(0, downloadedTemplate);
        });

        await _saveDownloadedTemplates();
        _showSuccessSnackBar('Template downloaded successfully!');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to download template');
    }
  }

  Future<void> _shareTemplate(String content, String title) async {
    try {
      await Share.share(content, subject: title);
    } catch (e) {
      _showErrorSnackBar('Failed to share template');
    }
  }

  Future<void> _deleteTemplate(String id) async {
    setState(() {
      _downloadedTemplates.removeWhere((template) => template.id == id);
    });
    await _saveDownloadedTemplates();
    _showSuccessSnackBar('Template deleted');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade900,
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade900,
            ],
          ),
        ),
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Template Generator',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.orange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: 'Generate'),
                  Tab(text: 'Downloads'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildGenerateTab(), _buildDownloadsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Fields
            _buildInputField(
              'Topic *',
              'Enter the topic for the template',
              _topicController,
              Icons.topic,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              'Grade Level *',
              'e.g., Grade 5, High School, College',
              _gradeLevelController,
              Icons.school,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              'Subject *',
              'e.g., Mathematics, Science, History',
              _subjectController,
              Icons.book,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              'Duration (Optional)',
              'e.g., 60 minutes, 2 hours',
              _durationController,
              Icons.schedule,
            ),
            const SizedBox(height: 24),

            // Generate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generateTemplate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isGenerating
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Generating...'),
                        ],
                      )
                    : const Text(
                        'Generate Template',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // Generated Template Display
            if (_generatedTemplate.isNotEmpty) ...[
              const Text(
                'Generated Template',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _downloadTemplate,
                              icon: const Icon(Icons.download, size: 18),
                              label: const Text('Download'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _shareTemplate(
                                _generatedTemplate,
                                'Generated Template',
                              ),
                              icon: const Icon(Icons.share, size: 18),
                              label: const Text('Share'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Template Content
                    Divider(color: Colors.white.withOpacity(0.2)),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: SelectableText(
                          _generatedTemplate,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadsTab() {
    return _downloadedTemplates.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  size: 64,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No downloaded templates yet',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Generate and download templates to see them here',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _downloadedTemplates.length,
            itemBuilder: (context, index) {
              final template = _downloadedTemplates[index];
              return _buildDownloadedTemplateCard(template);
            },
          );
  }

  Widget _buildDownloadedTemplateCard(DownloadedTemplate template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        title: Text(
          template.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${template.subject} • ${template.gradeLevel} • ${_formatDate(template.downloadDate)}',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _shareTemplate(template.content, template.title),
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _deleteTemplate(template.id),
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SingleChildScrollView(
                    child: Text(
                      template.content,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.orange, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class DownloadedTemplate {
  final String id;
  final String title;
  final String subject;
  final String gradeLevel;
  final String content;
  final DateTime downloadDate;
  final String? filePath;

  DownloadedTemplate({
    required this.id,
    required this.title,
    required this.subject,
    required this.gradeLevel,
    required this.content,
    required this.downloadDate,
    this.filePath,
  });

  factory DownloadedTemplate.fromJson(Map<String, dynamic> json) {
    return DownloadedTemplate(
      id: json['id'],
      title: json['title'],
      subject: json['subject'],
      gradeLevel: json['gradeLevel'],
      content: json['content'],
      downloadDate: DateTime.parse(json['downloadDate']),
      filePath: json['filePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      'content': content,
      'downloadDate': downloadDate.toIso8601String(),
      'filePath': filePath,
    };
  }
}
