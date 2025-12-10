import 'package:flutter/material.dart';

class VideoTutorialPage extends StatefulWidget {
  const VideoTutorialPage({super.key});

  @override
  State<VideoTutorialPage> createState() => _VideoTutorialPageState();
}

class _VideoTutorialPageState extends State<VideoTutorialPage> {
  final TextEditingController _searchController = TextEditingController();
  List<VideoTutorial> _videoTutorials = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Flutter Development',
    'Dart Programming',
    'UI/UX Design',
    'Mobile Development',
    'Web Development',
    'Database',
    'API Integration',
    'State Management',
  ];

  @override
  void initState() {
    super.initState();
    _loadDefaultVideos();
  }

  Future<void> _loadDefaultVideos() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading default videos
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _videoTutorials = _getDefaultVideos();
      _isLoading = false;
    });
  }

  Future<void> _searchVideos(String query) async {
    if (query.trim().isEmpty) {
      _loadDefaultVideos();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate AI API call - replace with actual API endpoint
      await Future.delayed(const Duration(seconds: 2));

      // Mock response from AI API
      final mockResults = await _generateMockSearchResults(query);

      setState(() {
        _videoTutorials = mockResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to search videos. Please try again.');
    }
  }

  Future<List<VideoTutorial>> _generateMockSearchResults(String query) async {
    // This simulates AI API response with relevant video tutorials
    // In production, replace with actual API call to AI service
    return [
      VideoTutorial(
        id: '1',
        title: 'Introduction to $query',
        description: 'Learn the basics of $query from scratch',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/video1',
        duration: '15:30',
        views: '10.2K',
        category: 'Flutter Development',
        level: 'Beginner',
      ),
      VideoTutorial(
        id: '2',
        title: 'Advanced $query Techniques',
        description: 'Master advanced concepts and best practices',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/video2',
        duration: '45:20',
        views: '5.8K',
        category: 'Flutter Development',
        level: 'Advanced',
      ),
      VideoTutorial(
        id: '3',
        title: '$query - Complete Project Tutorial',
        description: 'Build a complete project using $query',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/video3',
        duration: '2:15:45',
        views: '25.1K',
        category: 'Mobile Development',
        level: 'Intermediate',
      ),
    ];
  }

  List<VideoTutorial> _getDefaultVideos() {
    return [
      VideoTutorial(
        id: '1',
        title: 'Flutter Basics for Beginners',
        description:
            'Start your Flutter journey with this comprehensive introduction',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/flutter-basics',
        duration: '28:45',
        views: '45.2K',
        category: 'Flutter Development',
        level: 'Beginner',
      ),
      VideoTutorial(
        id: '2',
        title: 'State Management with Provider',
        description: 'Learn how to implement effective state management',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/provider-tutorial',
        duration: '35:20',
        views: '22.8K',
        category: 'State Management',
        level: 'Intermediate',
      ),
      VideoTutorial(
        id: '3',
        title: 'Building Beautiful UIs in Flutter',
        description: 'Create stunning user interfaces with Flutter widgets',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/flutter-ui',
        duration: '42:15',
        views: '38.5K',
        category: 'UI/UX Design',
        level: 'Intermediate',
      ),
      VideoTutorial(
        id: '4',
        title: 'Dart Programming Fundamentals',
        description: 'Master the Dart programming language',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/dart-fundamentals',
        duration: '55:30',
        views: '31.7K',
        category: 'Dart Programming',
        level: 'Beginner',
      ),
      VideoTutorial(
        id: '5',
        title: 'API Integration in Flutter',
        description: 'Connect your Flutter app to REST APIs',
        thumbnailUrl: 'https://via.placeholder.com/300x200',
        videoUrl: 'https://example.com/api-integration',
        duration: '38:10',
        views: '19.3K',
        category: 'API Integration',
        level: 'Intermediate',
      ),
    ];
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });

    if (category == 'All') {
      _loadDefaultVideos();
    } else {
      setState(() {
        _videoTutorials = _getDefaultVideos()
            .where((video) => video.category == category)
            .toList();
      });
    }
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
                  const SizedBox(width: 10),
                  const Text(
                    'Video Tutorials',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search for video tutorials...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchVideos(_searchController.text);
                      },
                      icon: const Icon(Icons.send, color: Colors.cyan),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                  onSubmitted: (value) {
                    _searchVideos(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Category Filter
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        _filterByCategory(category);
                      },
                      backgroundColor: Colors.white.withOpacity(0.1),
                      selectedColor: Colors.cyan.withOpacity(0.3),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.7),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.cyan
                            : Colors.white.withOpacity(0.2),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Video List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                      ),
                    )
                  : _videoTutorials.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_library_outlined,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No videos found',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _videoTutorials.length,
                      itemBuilder: (context, index) {
                        final video = _videoTutorials[index];
                        return _buildVideoCard(video);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(VideoTutorial video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.08),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey.withOpacity(0.3),
                  child: const Icon(
                    Icons.play_circle_outline,
                    size: 60,
                    color: Colors.white70,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video.duration,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  video.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getLevelColor(video.level).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getLevelColor(video.level).withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        video.level,
                        style: TextStyle(
                          color: _getLevelColor(video.level),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.cyan.withOpacity(0.5)),
                      ),
                      child: Text(
                        video.category,
                        style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          video.views,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

class VideoTutorial {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;
  final String views;
  final String category;
  final String level;

  VideoTutorial({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.views,
    required this.category,
    required this.level,
  });
}
