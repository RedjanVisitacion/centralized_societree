import 'package:flutter/material.dart';
import 'dart:ui';
import 'home_page.dart';
import 'resources_hub_page.dart';
import 'services_page.dart';

class NewsItem {
  final String id;
  final String title;
  final String date;
  final String shortDescription;
  final String fullContent;
  final IconData icon;
  final Color color;
  final String author;
  final String category;
  final String readTime;
  final List<String> highlights;

  NewsItem({
    required this.id,
    required this.title,
    required this.date,
    required this.shortDescription,
    required this.fullContent,
    required this.icon,
    required this.color,
    required this.author,
    required this.category,
    required this.readTime,
    required this.highlights,
  });
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedIndex = 1;

  late List<NewsItem> newsItems;

  @override
  void initState() {
    super.initState();
    newsItems = [
      NewsItem(
        id: '1',
        title: 'Breaking: New Tech Innovation',
        date: 'Dec 6, 2025',
        shortDescription:
            'Discover the latest breakthrough in artificial intelligence and machine learning technologies.',
        fullContent:
            'The tech industry has been revolutionized with a groundbreaking announcement from leading AI researchers. This breakthrough in artificial intelligence and machine learning technologies promises to transform how we interact with digital systems.\n\nKey developments include:\n• Advanced neural network architecture\n• Enhanced processing capabilities\n• Real-time adaptation algorithms\n\nExperts believe this innovation will have far-reaching implications across industries, from healthcare to finance. The team behind this achievement has spent over 5 years in research and development, and the results are now being made available to the global tech community.',
        icon: Icons.lightbulb_outline_rounded,
        color: Colors.blue,
        author: 'Dr. Sarah Johnson',
        category: 'Technology',
        readTime: '5 min read',
        highlights: [
          'Advanced neural networks',
          'Machine learning',
          'AI innovation',
        ],
      ),
      NewsItem(
        id: '2',
        title: 'Global Sports Update',
        date: 'Dec 5, 2025',
        shortDescription:
            'Stay updated with the latest scores, standings, and highlights from worldwide sporting events.',
        fullContent:
            'The world of sports continues to bring excitement and drama as teams compete at the highest levels. This comprehensive update covers all the major sporting events happening globally.\n\nTop Stories:\n• Championship finals reaching climax\n• Record-breaking performances\n• Historic upsets and surprises\n\nAthletes from around the world are pushing their limits and creating memorable moments. From football to basketball, tennis to athletics, every sport is delivering thrilling action. Stay tuned for live updates and in-depth analysis of your favorite teams and athletes.',
        icon: Icons.sports_soccer_rounded,
        color: Colors.orange,
        author: 'Mark Williams',
        category: 'Sports',
        readTime: '4 min read',
        highlights: [
          'Championship finals',
          'Record-breaking',
          'Global competitions',
        ],
      ),
      NewsItem(
        id: '3',
        title: 'Market Analysis Report',
        date: 'Dec 4, 2025',
        shortDescription:
            'Comprehensive analysis of current market trends and economic indicators for investors.',
        fullContent:
            'Financial markets continue to respond to global economic indicators and geopolitical events. This detailed market analysis provides insights for both novice and experienced investors.\n\nMarket Highlights:\n• Index performance analysis\n• Commodity price trends\n• Currency exchange updates\n\nWith volatility in certain sectors, investors are advised to diversify their portfolios. Our expert analysts have identified key opportunities and potential risks in various market segments. This comprehensive report helps you make informed investment decisions based on current market conditions.',
        icon: Icons.trending_up_rounded,
        color: Colors.green,
        author: 'Richard Chen',
        category: 'Finance',
        readTime: '6 min read',
        highlights: [
          'Market trends',
          'Investment analysis',
          'Economic indicators',
        ],
      ),
      NewsItem(
        id: '4',
        title: 'Health & Wellness Tips',
        date: 'Dec 3, 2025',
        shortDescription:
            'Expert advice on maintaining a healthy lifestyle and wellness practices.',
        fullContent:
            'Maintaining good health is essential for a happy and productive life. Our health experts have compiled the latest wellness tips and practices supported by scientific research.\n\nWellness Focus Areas:\n• Physical fitness routines\n• Mental health practices\n• Nutritional guidelines\n\nFrom morning exercise routines to meditation practices, this comprehensive guide covers everything you need to know about maintaining optimal health. Experts recommend a balanced approach combining physical activity, proper nutrition, and mental well-being. Start your wellness journey today with our detailed recommendations.',
        icon: Icons.health_and_safety_rounded,
        color: Colors.red,
        author: 'Dr. Emily Foster',
        category: 'Health',
        readTime: '5 min read',
        highlights: [
          'Fitness routines',
          'Mental health',
          'Nutrition',
        ],
      ),
      NewsItem(
        id: '5',
        title: 'Educational Resources',
        date: 'Dec 2, 2025',
        shortDescription:
            'New learning materials and courses available for professional development.',
        fullContent:
            'Education is the key to personal and professional growth. New and exciting learning materials are now available to help you advance your skills and knowledge.\n\nAvailable Courses:\n• Advanced programming languages\n• Professional certifications\n• Skill development workshops\n\nOur comprehensive education platform offers resources for learners of all levels. Whether you are looking to start a new career or advance in your current field, we have courses tailored to your needs. Join thousands of learners who have already transformed their careers through our educational programs.',
        icon: Icons.school_rounded,
        color: Colors.purple,
        author: 'Prof. Michael Davis',
        category: 'Education',
        readTime: '4 min read',
        highlights: [
          'Professional courses',
          'Certifications',
          'Skill development',
        ],
      ),
    ];
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
              Color.fromARGB(255, 216, 156, 16),
              Color.fromARGB(255, 3, 16, 85),
              Color.fromARGB(255, 0, 38, 88),
            ],
          ),
        ),
        child: Column(
          children: [
            // Custom AppBar - without back button
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  const Text(
                    'News & Updates',
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
            // News Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ...newsItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < newsItems.length - 1 ? 15 : 0,
                          ),
                          child: _buildNewsCard(item),
                        );
                      }),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade900,
            ],
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
              // Navigate to appropriate page
              if (index == 0) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              } else if (index == 2) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ResourcesHubPage(),
                  ),
                );
              } else if (index == 3) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ServicesPage(),
                  ),
                );
              }
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.cyan.shade300,
            unselectedItemColor: Colors.white60,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                  size: 26,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 1 ? Icons.newspaper : Icons.newspaper_outlined,
                  size: 26,
                ),
                label: 'News',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 2 ? Icons.library_books : Icons.library_books_outlined,
                  size: 26,
                ),
                label: 'Resources',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 3 ? Icons.design_services : Icons.design_services_outlined,
                  size: 26,
                ),
                label: 'Services',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(NewsItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewsDetailPage(item: item),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.08),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [item.color.withOpacity(0.6), item.color],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.shortDescription,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: item.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.readTime,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Read More',
                      style: TextStyle(
                        fontSize: 12,
                        color: item.color,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: item.color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final NewsItem item;

  const NewsDetailPage({
    super.key,
    required this.item,
  });

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
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: Colors.deepPurple.shade900,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            item.color.withOpacity(0.3),
                            item.color.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              item.color.withOpacity(0.6),
                              item.color,
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: item.color.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          item.icon,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.12),
                                Colors.white.withOpacity(0.08),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.3,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          item.color.withOpacity(0.6),
                                          item.color,
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.author,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      Text(
                                        item.date,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item.color.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item.category,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: item.color,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      color: Colors.cyan.shade300,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      item.readTime,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.cyan.shade300,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.12),
                                Colors.white.withOpacity(0.08),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Full Article',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.fullContent,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.85),
                                  height: 1.8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.12),
                                Colors.white.withOpacity(0.08),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Key Highlights',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...item.highlights.map((highlight) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              item.color.withOpacity(0.6),
                                              item.color,
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          highlight,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white
                                                .withOpacity(0.8),
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
