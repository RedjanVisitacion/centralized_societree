import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math';

class SupportMessage {
  final String id;
  final String sender; // 'Admin' or 'User'
  final String message;
  final DateTime timestamp;
  final bool isUser;
  final bool isRead;
  final String? imageUrl;

  SupportMessage({
    required this.id,
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.isUser,
    this.isRead = false,
    this.imageUrl,
  });

  SupportMessage copyWith({
    String? id,
    String? sender,
    String? message,
    DateTime? timestamp,
    bool? isUser,
    bool? isRead,
    String? imageUrl,
  }) {
    return SupportMessage(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isUser: isUser ?? this.isUser,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final _inputController = TextEditingController();
  final _listController = ScrollController();
  final _searchController = TextEditingController();

  final List<SupportMessage> _messages = [];
  bool _isInChat = false;
  bool _isTyping = false;
  bool _isSearching = false;
  final bool _isAdminOnline = true;
  Timer? _typingTimer;
  Timer? _adminResponseTimer;
  String _searchQuery = '';

  // Admin response templates
  final List<String> _adminResponses = [
    'I understand your concern. Let me help you with that.',
    'Thank you for reaching out. I\'ll look into this matter.',
    'I appreciate your patience. How can I assist you further?',
    'That\'s a good question. Let me provide you with the information.',
    'I\'m here to help. Could you provide more details?',
    'Thank you for your feedback. We\'ll work on improving this.',
    'I\'ve received your message and I\'m working on a solution.',
    'Is there anything else I can help you with?',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _listController.dispose();
    _searchController.dispose();
    _typingTimer?.cancel();
    _adminResponseTimer?.cancel();
    super.dispose();
  }

  void _sendFirstConcern() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();

    // Populate chat with initial flow
    final adminGreet = SupportMessage(
      id: '${now.millisecondsSinceEpoch}-a1',
      sender: 'Admin',
      message: 'Hi there, how can I help you?',
      timestamp: now.subtract(const Duration(minutes: 1)),
      isUser: false,
      isRead: true,
    );

    final userMsg = SupportMessage(
      id: '${now.millisecondsSinceEpoch}-u1',
      sender: 'User',
      message: text,
      timestamp: now,
      isUser: true,
    );

    setState(() {
      _messages
        ..clear()
        ..addAll([adminGreet, userMsg]);
      _isInChat = true;
      _inputController.clear();
    });

    _scrollToBottom();
    _simulateAdminResponse();
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final msg = SupportMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: 'User',
      message: text,
      timestamp: DateTime.now(),
      isUser: true,
    );

    setState(() {
      _messages.add(msg);
      _inputController.clear();
      _isTyping = false;
    });

    _scrollToBottom();
    _simulateAdminResponse();
  }

  void _simulateAdminResponse() {
    // Cancel any existing timer
    _adminResponseTimer?.cancel();

    // Show typing indicator after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });
        _scrollToBottom();
      }
    });

    // Send admin response after typing indicator
    _adminResponseTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        final random = Random();
        final response =
            _adminResponses[random.nextInt(_adminResponses.length)];

        final adminMsg = SupportMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: 'Admin',
          message: response,
          timestamp: DateTime.now(),
          isUser: false,
          isRead: true,
        );

        setState(() {
          _messages.add(adminMsg);
          _isTyping = false;
        });

        _scrollToBottom();
      }
    });
  }

  void _onTextChanged(String text) {
    // Reset typing timer
    _typingTimer?.cancel();

    if (text.isNotEmpty) {
      _typingTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isTyping = false;
          });
        }
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  List<SupportMessage> get _filteredMessages {
    if (_searchQuery.isEmpty) return _messages;
    return _messages
        .where(
          (msg) =>
              msg.message.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_listController.hasClients) return;
      _listController.animateTo(
        _listController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 149, 8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Contact Support',
              style: TextStyle(
                color: Color.fromARGB(221, 255, 255, 255),
                fontWeight: FontWeight.w700,
              ),
            ),
            if (_isInChat) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _isAdminOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        actions: _isInChat
            ? [
                IconButton(
                  icon: Icon(_isSearching ? Icons.close : Icons.search),
                  onPressed: _toggleSearch,
                ),
              ]
            : null,
      ),
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
        child: _isInChat ? _buildChatView() : _buildWelcomeView(),
      ),
    );
  }

  Widget _buildWelcomeView() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/pafelogo.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Hi, User',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(221, 255, 255, 255),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'How can I help you?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: _buildInputBar(
              hint: 'Write your message here',
              onSend: _sendFirstConcern,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatView() {
    return SafeArea(
      child: Column(
        children: [
          // Search bar
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search messages...',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _listController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: _filteredMessages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _filteredMessages.length && _isTyping) {
                  return _buildTypingIndicator();
                }

                final msg = _filteredMessages[index];
                final isUser = msg.isUser;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        _buildAvatar(isUser: false),
                        const SizedBox(width: 8),
                        _buildBubble(msg),
                        const SizedBox(width: 8),
                        // Online status indicator for admin
                        if (index == _filteredMessages.length - 1 &&
                            !isUser &&
                            _isAdminOnline)
                          _buildOnlineIndicator(),
                      ] else ...[
                        // User side
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(child: _buildBubble(msg, isUser: true)),
                              const SizedBox(width: 8),
                              _buildAvatar(isUser: true),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: _buildInputBar(hint: 'Message', onSend: _sendMessage),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar({required bool isUser}) {
    if (isUser) {
      return const CircleAvatar(
        radius: 18,
        backgroundColor: Color(0xFFEEF2F7),
        child: Icon(Icons.person, color: Colors.black54),
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white,
      backgroundImage: const AssetImage('assets/pafelogo.jpg'),
      onBackgroundImageError: (_, __) {},
    );
  }

  Widget _buildBubble(SupportMessage msg, {bool isUser = false}) {
    return Flexible(
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: isUser ? 0 : 6,
              right: isUser ? 6 : 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.sender,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!isUser && _isAdminOnline) ...[
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF1E88E5) : const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              msg.message,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 13.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(msg.timestamp),
                style: const TextStyle(fontSize: 10, color: Colors.black38),
              ),
              if (isUser) ...[
                const SizedBox(width: 4),
                Icon(
                  msg.isRead ? Icons.done_all : Icons.done,
                  size: 12,
                  color: msg.isRead ? Colors.blue : Colors.black38,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Online',
          style: TextStyle(fontSize: 10, color: Colors.green),
        ),
        const SizedBox(height: 6),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(isUser: false),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (sin((value * 2 * pi) + (index * pi / 3)) + 1) * 0.25,
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dt) {
    try {
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return '';
    }
  }

  Widget _buildInputBar({required String hint, required VoidCallback onSend}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _inputController,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.black54),
                  onPressed: _showAttachmentOptions,
                ),
              ),
              onSubmitted: (_) => onSend(),
              onChanged: _onTextChanged,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onSend,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _inputController.text.trim().isNotEmpty
                    ? const Color(0xFF1E88E5)
                    : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Send Image'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement image picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner),
              title: const Text('Send Document'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement document picker
              },
            ),
          ],
        ),
      ),
    );
  }
}
