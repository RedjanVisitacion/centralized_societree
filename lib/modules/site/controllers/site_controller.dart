import 'package:flutter/material.dart';
import 'package:centralized_societree/services/user_session.dart';

class SiteHomeScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const SiteHomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = UserSession.studentId ?? 'User';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context, userName),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upcoming Events Section
                    _buildSectionTitle('Upcoming Events', theme),
                    const SizedBox(height: 12),
                    _buildEventCard(context),

                    const SizedBox(height: 32),

                    // Categories Section
                    _buildSectionTitle('Categories', theme),
                    const SizedBox(height: 16),
                    _buildCategoriesGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFDB913),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF2C5F5D),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),

          const SizedBox(width: 16),

          // Greeting
          Expanded(
            child: Text(
              'Hi, $userName',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // Help Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'HELP',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFDB913),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildEventCard(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/SITE.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          'SITE EVENTS',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      _CategoryItem(
        icon: Icons.check_circle_outline,
        label: 'Attendance',
        color: const Color(0xFFFFF4E6),
        iconColor: const Color(0xFFFFA726),
        onTap: () => onNavigate(1),
      ),
      _CategoryItem(
        icon: Icons.event,
        label: 'Events',
        color: const Color(0xFFE8DEF8),
        iconColor: const Color(0xFF9C27B0),
        onTap: () => onNavigate(2),
      ),
      _CategoryItem(
        icon: Icons.notifications_outlined,
        label: 'Notifications',
        color: const Color(0xFFFCE4EC),
        iconColor: const Color(0xFFE91E63),
        onTap: () => onNavigate(3),
      ),
      _CategoryItem(
        icon: Icons.message_outlined,
        label: 'Messages',
        color: const Color(0xFFE1F5FE),
        iconColor: const Color(0xFF2196F3),
        onTap: () => onNavigate(4),
      ),
      _CategoryItem(
        icon: Icons.grid_view,
        label: 'Services\nOffered',
        color: const Color(0xFFE8F5E9),
        iconColor: const Color(0xFF4CAF50),
        onTap: () => onNavigate(5),
      ),
      _CategoryItem(
        icon: Icons.person_outline,
        label: 'Profile',
        color: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
        onTap: () => onNavigate(6),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryButton(category: category);
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: true,
                onTap: () {},
              ),
              _BottomNavItem(
                icon: Icons.check_circle_outline,
                label: 'Attendance',
                isSelected: false,
                onTap: () => onNavigate(1),
              ),
              _BottomNavItem(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Balance Inquiry',
                isSelected: false,
                onTap: () => onNavigate(7),
              ),
              _BottomNavItem(
                icon: Icons.grid_view,
                label: 'Services',
                isSelected: false,
                onTap: () => onNavigate(5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  _CategoryItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });
}

class _CategoryButton extends StatelessWidget {
  final _CategoryItem category;

  const _CategoryButton({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: category.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, size: 32, color: category.iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            category.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? const Color(0xFFFDB913) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? const Color(0xFFFDB913) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
