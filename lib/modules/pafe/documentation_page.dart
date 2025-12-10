import 'package:flutter/material.dart';

class Documentation {
  final int id;
  final String title;
  final String category;
  final String description;
  final String content;
  final bool aiGenerated;

  const Documentation({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.content,
    this.aiGenerated = false,
  });
}

class DownloadedFile {
  final String id;
  final String title;
  final String content;
  final DateTime downloadedAt;

  DownloadedFile({
    required this.id,
    required this.title,
    required this.content,
    required this.downloadedAt,
  });
}

class DocumentationPage extends StatefulWidget {
  const DocumentationPage({super.key});

  @override
  State<DocumentationPage> createState() => _DocumentationPageState();
}

class _DocumentationPageState extends State<DocumentationPage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentTab = 0; // 0 = Documentation, 1 = Downloads
  List<Documentation> _searchResults = [];
  final List<Documentation> _allDocumentation = [
    Documentation(
      id: 1,
      title: 'Flutter Development Guide',
      category: 'Flutter',
      description:
          'Complete guide to Flutter development including state management, navigation, and best practices.',
      content:
          'This comprehensive guide covers:\n• Basic Flutter widgets and layouts\n• State management with Provider and Riverpod\n• Navigation and routing\n• Async programming in Flutter\n• Performance optimization\n• Testing strategies',
      aiGenerated: true,
    ),
    Documentation(
      id: 2,
      title: 'Dart Programming Fundamentals',
      category: 'Dart',
      description: 'Learn Dart language essentials for Flutter development.',
      content:
          'Key topics:\n• Variables and data types\n• Functions and closures\n• Classes and inheritance\n• Async/await patterns\n• Collections (List, Map, Set)\n• Error handling',
      aiGenerated: true,
    ),
    Documentation(
      id: 3,
      title: 'UI/UX Design Principles',
      category: 'Design',
      description:
          'Essential principles for creating beautiful and user-friendly interfaces.',
      content:
          'Design fundamentals:\n• Color theory and palettes\n• Typography and readability\n• Spacing and alignment\n• Glassmorphism effects\n• Accessibility guidelines\n• Responsive design patterns',
      aiGenerated: true,
    ),
    Documentation(
      id: 4,
      title: 'Mobile App Architecture',
      category: 'Architecture',
      description:
          'Best practices for structuring scalable mobile applications.',
      content:
          'Architecture patterns:\n• MVVM pattern implementation\n• Repository pattern for data\n• Dependency injection\n• Clean code principles\n• Project structure organization\n• Testing layers',
      aiGenerated: true,
    ),
    Documentation(
      id: 5,
      title: 'API Integration & Networking',
      category: 'Backend',
      description:
          'Guide to integrating APIs and handling network requests in Flutter apps.',
      content:
          'Networking essentials:\n• HTTP requests with Dio\n• JSON serialization\n• Error handling\n• Caching strategies\n• Authentication tokens\n• Rate limiting',
      aiGenerated: true,
    ),
  ];

  final List<DownloadedFile> _downloads = [];
  bool _isGenerating = false;
  String _generatedContent = '';

  @override
  void initState() {
    super.initState();
    _searchResults = _allDocumentation;
  }

  void _searchDocumentation(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = _allDocumentation;
      } else {
        _searchResults = _allDocumentation
            .where(
              (doc) =>
                  doc.title.toLowerCase().contains(query.toLowerCase()) ||
                  doc.category.toLowerCase().contains(query.toLowerCase()) ||
                  doc.description.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _generateLessonPlan(String topic) {
    setState(() {
      _isGenerating = true;
    });

    // Simulate AI generation with a delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _generatedContent = _generateAIContent(topic);
        _isGenerating = false;
      });

      _showLessonPlanDialog();
    });
  }

  String _generateAIContent(String topic) {
    final lessonPlans = {
      'Flutter Development Guide': '''
📚 GENERATED LESSON PLAN: Flutter Development Guide

🎯 Learning Objectives:
• Understand Flutter architecture and widget system
• Master state management techniques
• Implement responsive UI design
• Build production-ready applications

📖 Curriculum Structure:

Week 1-2: Foundations
├─ Flutter installation and setup
├─ Widget fundamentals (StatelessWidget, StatefulWidget)
├─ Layout widgets and constraints
└─ Hot reload and debugging

Week 3-4: Navigation & State Management
├─ Named routing
├─ Provider pattern implementation
├─ Local state vs global state
└─ BLoC pattern basics

Week 5-6: Advanced Topics
├─ Custom animations
├─ Platform channels
├─ Firebase integration
└─ Performance optimization

Week 7-8: Project Development
├─ Real-world application building
├─ Testing strategies
├─ App store deployment
└─ Maintenance best practices

🔗 Resources:
• Official Flutter documentation
• Flutter community packages
• Video tutorials and courses
• Practice projects

⏱️ Estimated Duration: 8 weeks (20-25 hours/week)
📊 Difficulty Level: Intermediate to Advanced
✅ Prerequisites: Basic programming knowledge
      ''',
      'Dart Programming Fundamentals': '''
📚 GENERATED LESSON PLAN: Dart Programming Fundamentals

🎯 Learning Objectives:
• Master Dart syntax and semantics
• Understand object-oriented programming concepts
• Learn functional programming patterns
• Write efficient and clean code

📖 Curriculum Structure:

Module 1: Language Basics
├─ Variables and types (var, final, const)
├─ Operators and expressions
├─ Control flow (if, for, while)
└─ Functions and closures

Module 2: Object-Oriented Programming
├─ Classes and objects
├─ Inheritance and mixins
├─ Abstraction and interfaces
└─ Polymorphism

Module 3: Functional Programming
├─ Higher-order functions
├─ Map, filter, reduce operations
├─ Futures and streams
└─ Async/await patterns

Module 4: Advanced Concepts
├─ Generics and type safety
├─ Exception handling
├─ Null safety
└─ Performance considerations

📚 Practice Exercises:
• 30+ coding challenges
• Real-world applications
• Algorithm problems
• Debugging exercises

⏱️ Estimated Duration: 6 weeks (15-20 hours/week)
📊 Difficulty Level: Beginner to Intermediate
✅ Prerequisites: None
      ''',
      'UI/UX Design Principles': '''
📚 GENERATED LESSON PLAN: UI/UX Design Principles

🎯 Learning Objectives:
• Create beautiful and intuitive interfaces
• Understand user experience fundamentals
• Master design systems and consistency
• Implement modern design trends

📖 Curriculum Structure:

Phase 1: Design Fundamentals
├─ Color theory and psychology
├─ Typography hierarchy
├─ Layout and composition
└─ Whitespace and alignment

Phase 2: UX Research & Testing
├─ User research methods
├─ Usability testing
├─ A/B testing strategies
└─ User feedback incorporation

Phase 3: Modern Design Trends
├─ Glassmorphism effects
├─ Gradient applications
├─ Micro-interactions
└─ Dark mode design

Phase 4: Accessibility & Responsiveness
├─ WCAG guidelines
├─ Color contrast ratios
├─ Mobile responsiveness
└─ Touch-friendly interfaces

🎨 Design Projects:
• Mobile app design
• Web interface redesign
• Design system creation
• Prototype development

⏱️ Estimated Duration: 5 weeks (12-18 hours/week)
📊 Difficulty Level: Beginner to Intermediate
✅ Prerequisites: Basic design appreciation
      ''',
      'Mobile App Architecture': '''
📚 GENERATED LESSON PLAN: Mobile App Architecture

🎯 Learning Objectives:
• Design scalable application structures
• Implement architectural patterns
• Manage dependencies effectively
• Build testable applications

📖 Curriculum Structure:

Section 1: Architectural Patterns
├─ MVVM architecture
├─ Repository pattern
├─ Dependency injection
└─ Service locator pattern

Section 2: Project Organization
├─ Folder structure best practices
├─ Separation of concerns
├─ Module organization
└─ Code sharing strategies

Section 3: Data Management
├─ Local database design
├─ Caching strategies
├─ Data synchronization
└─ Offline-first approach

Section 4: Testing & Quality
├─ Unit testing
├─ Integration testing
├─ Widget testing
└─ Test coverage analysis

🏗️ Case Studies:
• Large-scale application design
• Performance optimization
• Scaling strategies
• Legacy code refactoring

⏱️ Estimated Duration: 7 weeks (18-22 hours/week)
📊 Difficulty Level: Advanced
✅ Prerequisites: Flutter and Dart knowledge
      ''',
      'API Integration & Networking': '''
📚 GENERATED LESSON PLAN: API Integration & Networking

🎯 Learning Objectives:
• Integrate RESTful and GraphQL APIs
• Handle network requests efficiently
• Implement robust error handling
• Secure API communications

📖 Curriculum Structure:

Topic 1: HTTP Fundamentals
├─ HTTP methods and status codes
├─ Request/response cycle
├─ Headers and body management
└─ REST principles

Topic 2: Integration Libraries
├─ Dio package advanced usage
├─ HTTP client configuration
├─ Interceptors and middleware
└─ Request/response transformation

Topic 3: Data Serialization
├─ JSON parsing and encoding
├─ Model generation (JSON to Dart)
├─ Type safety
└─ Custom serialization

Topic 4: Error & Exception Handling
├─ Network error types
├─ Retry strategies
├─ Timeout management
└─ User-friendly error messages

Topic 5: Security & Performance
├─ SSL/TLS implementation
├─ Token-based authentication
├─ Request caching
└─ Bandwidth optimization

🔌 Practical Projects:
• Weather app with API integration
• Social media client
• E-commerce platform
• Real-time data synchronization

⏱️ Estimated Duration: 6 weeks (16-20 hours/week)
📊 Difficulty Level: Intermediate
✅ Prerequisites: Dart and Flutter basics
      ''',
    };

    return lessonPlans[topic] ??
        '''
📚 GENERATED LESSON PLAN: $topic

Generated by AI Learning System

🎯 Key Topics:
• Introduction to $topic
• Core concepts and principles
• Practical implementation
• Best practices and optimization
• Advanced techniques
• Real-world applications

⏱️ Estimated Duration: 4-8 weeks
📊 Difficulty Level: Intermediate
✅ Start learning now!
    ''';
  }

  void _showLessonPlanDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.deepPurple.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600, maxWidth: 600),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AI Generated Lesson Plan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white.withOpacity(0.7),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _generatedContent,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.6,
                    ),
                  ),
                ),
              ),
              // Footer
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: const Text(
                            'Close',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Add to downloads list
                          final downloadedFile = DownloadedFile(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            title: _generatedContent
                                .split('\n')
                                .first
                                .replaceAll('📚 GENERATED LESSON PLAN: ', ''),
                            content: _generatedContent,
                            downloadedAt: DateTime.now(),
                          );

                          setState(() {
                            _downloads.add(downloadedFile);
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(
                                    Icons.download_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Lesson plan downloaded successfully',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.cyan.shade300,
                                Colors.blue.shade400,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.download_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Download',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const Text(
                    'Documentation',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentTab = 1; // Switch to Downloads tab
                      });
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          if (_downloads.isNotEmpty)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  _downloads.length > 9
                                      ? '9+'
                                      : _downloads.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tab Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentTab = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _currentTab == 0
                                  ? Colors.cyan.shade300
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          'Documentation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _currentTab == 0
                                ? Colors.cyan.shade300
                                : Colors.white.withOpacity(0.6),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentTab = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _currentTab == 1
                                  ? Colors.cyan.shade300
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          'Downloads (${_downloads.length})',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _currentTab == 1
                                ? Colors.cyan.shade300
                                : Colors.white.withOpacity(0.6),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),
            // Search Bar - Only show for Documentation tab
            _currentTab == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        onChanged: _searchDocumentation,
                        decoration: InputDecoration(
                          hintText: 'Search documentation...',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.4),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    _searchDocumentation('');
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 16),
            // Content Area - Shows Documentation or Downloads based on tab
            Expanded(
              child: _currentTab == 0
                  ? _buildDocumentationTab()
                  : _buildDownloadsTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentationTab() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No documentation found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ..._searchResults.asMap().entries.map((entry) {
            int index = entry.key;
            Documentation doc = entry.value;
            return Column(
              children: [
                _buildDocumentationCard(doc),
                if (index < _searchResults.length - 1)
                  const SizedBox(height: 12),
              ],
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDownloadsTab() {
    if (_downloads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_rounded,
              size: 80,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No downloads yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Generate and download lesson plans to view them here',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ..._downloads.asMap().entries.map((entry) {
            int index = entry.key;
            DownloadedFile file = entry.value;
            return Column(
              children: [
                _buildDownloadCard(file, index),
                if (index < _downloads.length - 1) const SizedBox(height: 12),
              ],
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDownloadCard(DownloadedFile file, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade700.withOpacity(0.15),
            Colors.green.shade600.withOpacity(0.08),
          ],
        ),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 1.5),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Downloaded: ${file.downloadedAt.toString().split('.')[0]}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Downloaded',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Preview
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              file.content.length > 200
                  ? '${file.content.substring(0, 200)}...'
                  : file.content,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.7),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showDownloadDetail(file);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.cyan.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility,
                          color: Colors.cyan.shade300,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'View',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.cyan.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _downloads.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Download deleted'),
                      backgroundColor: Colors.orange,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red.shade400,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDownloadDetail(DownloadedFile file) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade900,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1.5),
          ),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          file.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withOpacity(0.7),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Download Info
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Downloaded: ${file.downloadedAt.toString().split('.')[0]}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Content
                  Text(
                    'Content',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      file.content,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentationCard(Documentation doc) {
    return GestureDetector(
      onTap: () {
        _showDocumentationDetail(doc);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.12),
              Colors.white.withOpacity(0.08),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.cyan.shade300.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.cyan.shade300.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          doc.category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.cyan.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.4),
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Description
            Text(
              doc.description,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.6),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            // AI Badge and Generate Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'AI Generated',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _generateLessonPlan(doc.title),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade500,
                          Colors.purple.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isGenerating
                              ? Icons.hourglass_top_rounded
                              : Icons.school_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isGenerating ? 'Generating...' : 'Generate Plan',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDocumentationDetail(Documentation doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade900,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1.5),
          ),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          doc.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withOpacity(0.7),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.cyan.shade300.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.cyan.shade300.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      doc.category,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.cyan.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    doc.description,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Content
                  Text(
                    'Content',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      doc.content,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Action Buttons
                  Row(
                    children: [
                      // Download Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Add documentation to downloads
                            final downloadedFile = DownloadedFile(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              title: doc.title,
                              content: doc.content,
                              downloadedAt: DateTime.now(),
                            );

                            setState(() {
                              _downloads.add(downloadedFile);
                            });

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.download_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Documentation downloaded successfully',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade500,
                                  Colors.green.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.4),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.download_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Download',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Generate Lesson Plan Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _generateLessonPlan(doc.title);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade500,
                                  Colors.purple.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.4),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isGenerating
                                      ? Icons.hourglass_top_rounded
                                      : Icons.auto_awesome_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isGenerating
                                      ? 'Generating...'
                                      : 'Generate Plan',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
