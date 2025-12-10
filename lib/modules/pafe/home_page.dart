import 'package:flutter/material.dart';
import 'user_profile_page.dart';
import 'contact_support_page.dart';
import 'news_page.dart';
import 'resources_hub_page.dart';
import 'services_page.dart';
import 'documentation_page.dart';
import 'template_generator_page.dart';
import 'video_tutorial_page.dart';
import 'attendance_page.dart';
import 'feedback_page.dart';
import 'class_schedule_page.dart';
import 'view_events_page.dart';
import 'schedule_store.dart';

class EventItem {
  final String title;
  final String dateTime;
  final String category;
  final IconData icon;
  final Color color1;
  final Color color2;
  final String description;
  final String location;

  EventItem({
    required this.title,
    required this.dateTime,
    required this.category,
    required this.icon,
    required this.color1,
    required this.color2,
    required this.description,
    required this.location,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onSchedulesChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    scheduleStore.addListener(_onSchedulesChanged);
  }

  @override
  void dispose() {
    scheduleStore.removeListener(_onSchedulesChanged);
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
              Color.fromARGB(255, 216, 156, 16),
              Color.fromARGB(255, 3, 16, 85),
              Color.fromARGB(255, 0, 38, 88),
            ],
          ),
        ),
        child: Column(
          children: [
            // Top bar with profile and help button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User Profile Section
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UserProfilePage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          // Profile Avatar Circle
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade300,
                                  Colors.deepPurple.shade500,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.shade300.withOpacity(0.5),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Username
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ian Duman-ag',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'View Profile',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Help Button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ContactSupportPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan.shade300,
                            Colors.blue.shade400,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.help_outline_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main content with scroll
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Section
                      const Text(
                        'Discover Events',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Upcoming experiences tailored for you',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Upcoming Events Section
                      const Text(
                        'Featured Events',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Event Card 1
                      _buildModernEventCard(
                        EventItem(
                          title: 'Tech Conference 2025',
                          dateTime: 'Dec 15, 2025 - 10:00 AM',
                          category: 'Technology',
                          icon: Icons.computer,
                          color1: Colors.blue.shade400,
                          color2: Colors.blue.shade600,
                          description: 'Join industry leaders and innovators for an in-depth exploration of cutting-edge technologies shaping the future. Network with professionals and learn about the latest trends.',
                          location: 'Convention Center, Hall A',
                        ),
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ViewEventsPage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Event Card 2
                      _buildModernEventCard(
                        EventItem(
                          title: 'Sports Championship',
                          dateTime: 'Dec 20, 2025 - 06:00 PM',
                          category: 'Sports',
                          icon: Icons.sports_soccer,
                          color1: Colors.orange.shade400,
                          color2: Colors.orange.shade600,
                          description: 'Experience the excitement of the biggest sporting event of the season! Watch elite athletes compete for glory and be part of the action-packed championship.',
                          location: 'Sports Stadium, Main Arena',
                        ),
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ViewEventsPage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      // Your Class Schedule
                      _buildHomeScheduleSection(context),
                      const SizedBox(height: 35),
                      // Categories Section
                      const Text(
                        'Explore Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Categories Grid
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          _buildModernCategoryCard(
                            'Documents',
                            Icons.description_rounded,
                            [Colors.blue.shade400, Colors.blue.shade600],
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DocumentationPage(),
                              ),
                            ),
                          ),
                          _buildModernCategoryCard(
                            'Template',
                            Icons.dashboard,
                            [Colors.orange.shade400, Colors.orange.shade600],
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const TemplateGeneratorPage(),
                              ),
                            ),
                          ),
                          _buildModernCategoryCard(
                            'Video',
                            Icons.video_label,
                            [Colors.pink.shade400, Colors.pink.shade600],
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const VideoTutorialPage(),
                              ),
                            ),
                          ),
                          _buildModernCategoryCard(
                            'Attendance',
                            Icons.check_box,
                            [Colors.green.shade400, Colors.green.shade600],
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AttendancePage(),
                              ),
                            ),
                          ),
                          _buildModernCategoryCard(
                            'Feedback',
                            Icons.feedback_rounded,
                            [Colors.red.shade400, Colors.red.shade600],
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const FeedbackPage(),
                              ),
                            ),
                          ),
                          _buildModernCategoryCard(
                            'Class Schedule',
                            Icons.schedule,
                            [Colors.purple.shade400, Colors.purple.shade600],
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ClassSchedulePage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
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
              Color(0xFF133860),
              Color(0xFF0B1F3A),
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
              // Navigate to appropriate page based on index
              if (index == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NewsPage(),
                  ),
                );
              } else if (index == 2) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ResourcesHubPage(),
                  ),
                );
              } else if (index == 3) {
                Navigator.of(context).push(
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

  Widget _buildModernEventCard(
    EventItem item,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [item.color1, item.color2],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: item.color1.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      item.icon,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  const SizedBox(width: 16),
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
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.dateTime,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    item.color1.withOpacity(0.3),
                                    item.color2.withOpacity(0.3)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: item.color1.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                item.category,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: item.color1,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: item.color1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeScheduleSection(BuildContext context) {
    final schedules = scheduleStore.schedules;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.06),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Class Schedule',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          if (schedules.isEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No schedules yet',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ClassSchedulePage(),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, color: Colors.cyanAccent),
                    label: const Text(
                      'Create schedule',
                      style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            )
          else ...[
            ...schedules.take(3).map(_buildHomeScheduleCard),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ClassSchedulePage(),
                  ),
                ),
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHomeScheduleCard(Schedule s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
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
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.purple.shade600],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.schedule, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.subject,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person_rounded, size: 16, color: Colors.cyanAccent.withOpacity(0.9)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        s.instructor,
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 16, color: Colors.cyanAccent.withOpacity(0.9)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        s.days,
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (s.startTime != null && s.endTime != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 16, color: Colors.cyanAccent.withOpacity(0.9)),
                      const SizedBox(width: 6),
                      Text(
                        _formatTimeRange(context, s.startTime!, s.endTime!),
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeRange(BuildContext context, TimeOfDay start, TimeOfDay end) {
    return '${start.format(context)} - ${end.format(context)}';
  }

  Widget _buildModernCategoryCard(
    String title,
    IconData icon,
    List<Color> gradientColors,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
