import 'package:flutter/material.dart';

class ViewEventsPage extends StatefulWidget {
  const ViewEventsPage({super.key});

  @override
  State<ViewEventsPage> createState() => _ViewEventsPageState();
}

class Event {
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final String category;
  final String morningQrCode;
  final String afternoonQrCode;
  bool morningSessionOpen;
  bool afternoonSessionOpen;
  bool morningAttendance;
  bool afternoonAttendance;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.morningQrCode,
    required this.afternoonQrCode,
    this.morningSessionOpen = false,
    this.afternoonSessionOpen = false,
    this.morningAttendance = false,
    this.afternoonAttendance = false,
  });
}

class _ViewEventsPageState extends State<ViewEventsPage> {
  final List<Event> events = [
    Event(
      title: 'Flutter Workshop',
      description: 'Learn advanced Flutter development techniques and best practices for building scalable mobile applications.',
      date: '15 Dec, 2024',
      time: '09:00 AM - 05:00 PM',
      location: 'Tech Hall, Building A',
      category: 'Technology',
      morningQrCode: 'FLUTTER_MORNING_2024',
      afternoonQrCode: 'FLUTTER_AFTERNOON_2024',
      morningSessionOpen: true,
      afternoonSessionOpen: false,
    ),
    Event(
      title: 'AI & Machine Learning Summit',
      description: 'Explore the latest trends in AI and ML with industry experts. Network with professionals and learn about real-world applications.',
      date: '20 Dec, 2024',
      time: '10:00 AM - 04:00 PM',
      location: 'Conference Center',
      category: 'Technology',
      morningQrCode: 'AI_ML_MORNING_2024',
      afternoonQrCode: 'AI_ML_AFTERNOON_2024',
      morningSessionOpen: false,
      afternoonSessionOpen: true,
    ),
    Event(
      title: 'Business Networking Event',
      description: 'Connect with business leaders and entrepreneurs. Discuss opportunities and build professional relationships.',
      date: '22 Dec, 2024',
      time: '06:00 PM - 09:00 PM',
      location: 'Grand Hotel Ballroom',
      category: 'Business',
      morningQrCode: 'BUSINESS_MORNING_2024',
      afternoonQrCode: 'BUSINESS_AFTERNOON_2024',
      morningSessionOpen: false,
      afternoonSessionOpen: false,
    ),
  ];

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
            // Top Bar with Back Button
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
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
                    'View Events',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 45), // Placeholder for alignment
                ],
              ),
            ),
            // Events List
            Expanded(
              child: events.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_rounded,
                            size: 80,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No events available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          ...events.asMap().entries.map((entry) {
                            int index = entry.key;
                            Event event = entry.value;
                            return Column(
                              children: [
                                _buildEventCard(event, index),
                                if (index < events.length - 1)
                                  const SizedBox(height: 14),
                              ],
                            );
                          }),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event, int index) {
    return GestureDetector(
      onTap: () {
        _showEventDetails(event, index);
      },
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
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
                          event.category,
                          style: TextStyle(
                            fontSize: 11,
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
                  color: Colors.white.withOpacity(0.5),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Event Details
            _buildEventDetail(
              icon: Icons.calendar_today_rounded,
              label: event.date,
            ),
            const SizedBox(height: 8),
            _buildEventDetail(
              icon: Icons.access_time_rounded,
              label: event.time,
            ),
            const SizedBox(height: 8),
            _buildEventDetail(
              icon: Icons.location_on_rounded,
              label: event.location,
            ),
            const SizedBox(height: 12),
            // Session Status and Attendance
            Row(
              children: [
                Expanded(
                  child: _buildSessionStatus(
                    label: 'Morning',
                    isSessionOpen: event.morningSessionOpen,
                    isAttended: event.morningAttendance,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSessionStatus(
                    label: 'Afternoon',
                    isSessionOpen: event.afternoonSessionOpen,
                    isAttended: event.afternoonAttendance,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetail({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.cyan.shade300,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionStatus({
    required String label,
    required bool isSessionOpen,
    required bool isAttended,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: isAttended
            ? Colors.green.withOpacity(0.2)
            : isSessionOpen
                ? Colors.blue.withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAttended
              ? Colors.green.withOpacity(0.5)
              : isSessionOpen
                  ? Colors.blue.withOpacity(0.5)
                  : Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isAttended
                ? Icons.check_circle_rounded
                : isSessionOpen
                    ? Icons.qr_code_2_rounded
                    : Icons.lock_clock_rounded,
            size: 16,
            color: isAttended
                ? Colors.green
                : isSessionOpen
                    ? Colors.blue
                    : Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isAttended
                  ? Colors.green
                  : isSessionOpen
                      ? Colors.blue
                      : Colors.white.withOpacity(0.6),
            ),
          ),
          if (isSessionOpen)
            Text(
              'Open',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Colors.blue.withOpacity(0.8),
              ),
            ),
          if (!isSessionOpen && !isAttended)
            Text(
              'Closed',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }

  void _showEventDetails(Event event, int eventIndex) {
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
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
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
                          event.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
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
                  const SizedBox(height: 20),
                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Event Details
                  _buildDetailSection('Date & Time', event.date, Icons.calendar_today_rounded),
                  const SizedBox(height: 12),
                  _buildDetailSection('Time', event.time, Icons.access_time_rounded),
                  const SizedBox(height: 12),
                  _buildDetailSection('Location', event.location, Icons.location_on_rounded),
                  const SizedBox(height: 24),
                  // Morning Session
                  if (event.morningSessionOpen)
                    _buildSessionQRSection(
                      sessionName: 'Morning Session',
                      qrCode: event.morningQrCode,
                      isAttended: event.morningAttendance,
                      sessionColor: Colors.blue,
                      onMarkAttendance: () {
                        setState(() {
                          events[eventIndex].morningAttendance = !events[eventIndex].morningAttendance;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              events[eventIndex].morningAttendance
                                  ? 'Morning attendance marked ✓'
                                  : 'Morning attendance unmarked',
                            ),
                            backgroundColor: events[eventIndex].morningAttendance ? Colors.green : Colors.orange,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    )
                  else if (!event.morningAttendance)
                    _buildClosedSessionSection('Morning Session'),
                  const SizedBox(height: 20),
                  // Afternoon Session
                  if (event.afternoonSessionOpen)
                    _buildSessionQRSection(
                      sessionName: 'Afternoon Session',
                      qrCode: event.afternoonQrCode,
                      isAttended: event.afternoonAttendance,
                      sessionColor: Colors.orange,
                      onMarkAttendance: () {
                        setState(() {
                          events[eventIndex].afternoonAttendance = !events[eventIndex].afternoonAttendance;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              events[eventIndex].afternoonAttendance
                                  ? 'Afternoon attendance marked ✓'
                                  : 'Afternoon attendance unmarked',
                            ),
                            backgroundColor: events[eventIndex].afternoonAttendance ? Colors.green : Colors.orange,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    )
                  else if (!event.afternoonAttendance)
                    _buildClosedSessionSection('Afternoon Session'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionQRSection({
    required String sessionName,
    required String qrCode,
    required bool isAttended,
    required Color sessionColor,
    required VoidCallback onMarkAttendance,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.04),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: sessionColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: sessionColor.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.schedule_rounded,
                  color: sessionColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sessionName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      isAttended ? 'Attendance Marked ✓' : 'Scan QR to mark',
                      style: TextStyle(
                        fontSize: 12,
                        color: isAttended ? Colors.green : Colors.white.withOpacity(0.6),
                        fontWeight: isAttended ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (isAttended)
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 24,
                ),
            ],
          ),
          const SizedBox(height: 16),
          // QR Code
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_2_rounded,
                    size: 80,
                    color: sessionColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    qrCode,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: sessionColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Scan this QR code to mark $sessionName attendance',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onMarkAttendance,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [sessionColor, sessionColor.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: sessionColor.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isAttended ? Icons.check_circle_rounded : Icons.cloud_upload_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isAttended ? 'Marked' : 'Mark Attendance',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosedSessionSection(String sessionName) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.lock_clock_rounded,
              color: Colors.white.withOpacity(0.4),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              '$sessionName is currently closed',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Waiting for admin to publish this session',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.cyan.shade300,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

